Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbZCRODU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbZCRODU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZCRODI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:03:08 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:43364 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbZCRODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:03:06 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Mar 2009 10:03:06 EDT
Date: Wed, 18 Mar 2009 14:57:18 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Zhang Le <r0bertz@gentoo.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] proc:  Fix proc_tid_readdir so it handles the weird
	cases.
Message-ID: <20090318135718.GA32106@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
	torvalds@osdl.org, Zhang Le <r0bertz@gentoo.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, Oleg Nesterov <oleg@tv-sign.ru>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org> <m17i2okogv.fsf@fess.ebiederm.org> <20090318072720.GA20593@adriano.hkcable.com.hk> <m1mybjf77w.fsf@fess.ebiederm.org> <m1wsandk64.fsf_-_@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-11534-1237384634-0001-2"
Content-Disposition: inline
In-Reply-To: <m1wsandk64.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-11534-1237384634-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18/03/09  6:39 -0700, Eric W. Biederman wrote:
>=20
> Fix the logic in proc_task_readdir so that we provide the
> guarantee that in the sequence:
> opendir
> readdir
> readdir
> ....
> readdir
> closedir
> If a thread exists from the beginning until the end we are
> guaranteed to see it, even if some threads are created or
> worse are destroyed during the readdir.
>=20
> This guarantee is provided by reusing the same logic used
> by proc_pid_readdir for the root directory of /proc.  The
> pid is encoded into the offset, and we walk the pid bitmap
> of all pids in the system, and test each of them to see if
> it belongs to the specified thread group.
>=20
> If we seek to a bad location or if the task we say last
> exits it is ok because we can numerically find the next
> task we would have returned.
>=20
> This is slower that the previous version, but it should
> not be too slow as this techinique is already use for
> the root directory of /proc without problems.

This makes 'ps -T x' an O(n^2) thing, compared to O(n) before the patch, ri=
ght?
It would be good to, at least, check for thread_group_empty().

Thanks,

Louis

>=20
> Signed-off-by: Eric Biederman <ebiederm@xmission.com>
> ---
>  fs/proc/base.c |  141 +++++++++++++++++++++-----------------------------=
------
>  1 files changed, 53 insertions(+), 88 deletions(-)
>=20
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index beaa0ce..2d8e9c9 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2754,13 +2754,13 @@ retry:
>  	if (pid) {
>  		iter.tgid =3D pid_nr_ns(pid, ns);
>  		iter.task =3D pid_task(pid, PIDTYPE_PID);
> -		/* What we to know is if the pid we have find is the
> -		 * pid of a thread_group_leader.  Testing for task
> -		 * being a thread_group_leader is the obvious thing
> -		 * todo but there is a window when it fails, due to
> -		 * the pid transfer logic in de_thread.
> +		/* What we want to know is if the pid we have found is
> +		 * the pid of a thread_group_leader.  Testing for task
> +		 * being a thread_group_leader is the obvious thing to
> +		 * do but there is a window when it fails, due to the
> +		 * pid transfer logic in de_thread.
>  		 *
> -		 * So we perform the straight forward test of seeing
> +		 * So we perform the straight forward test, of seeing
>  		 * if the pid we have found is the pid of a thread
>  		 * group leader, and don't worry if the task we have
>  		 * found doesn't happen to be a thread group leader.
> @@ -2978,82 +2978,54 @@ out_no_task:
>  	return result;
>  }
> =20
> +
>  /*
> - * Find the first tid of a thread group to return to user space.
> - *
> - * Usually this is just the thread group leader, but if the users
> - * buffer was too small or there was a seek into the middle of the
> - * directory we have more work todo.
> - *
> - * In the case of a short read we start with find_task_by_pid.
> + * Find the next task in the thread group with tid >=3D tid.
> + * Return iter.task =3D=3D NULL if ther is an error or no next task.
>   *
> - * In the case of a seek we start with the leader and walk nr
> - * threads past it.
> + * The reference to the input task_struct is released.
>   */
> -static struct task_struct *first_tid(struct task_struct *leader,
> -		int tid, int nr, struct pid_namespace *ns)
> +struct tid_iter {
> +	struct task_struct *task;
> +	unsigned int tid;
> +};
> +static struct tid_iter next_tid(struct pid_namespace *ns, struct pid *tg=
id,
> +				struct tid_iter iter)
>  {
> -	struct task_struct *pos;
> +	struct pid *pid;
> =20
> +	if (iter.task)
> +		put_task_struct(iter.task);
>  	rcu_read_lock();
> -	/* Attempt to start with the pid of a thread */
> -	if (tid && (nr > 0)) {
> -		pos =3D find_task_by_pid_ns(tid, ns);
> -		if (pos && (pos->group_leader =3D=3D leader))
> -			goto found;
> -	}
> -
> -	/* If nr exceeds the number of threads there is nothing todo */
> -	pos =3D NULL;
> -	if (nr && nr >=3D get_nr_threads(leader))
> -		goto out;
> -
> -	/* If we haven't found our starting place yet start
> -	 * with the leader and walk nr threads forward.
> -	 */
> -	for (pos =3D leader; nr > 0; --nr) {
> -		pos =3D next_thread(pos);
> -		if (pos =3D=3D leader) {
> -			pos =3D NULL;
> -			goto out;
> +retry:
> +	iter.task =3D NULL;
> +	pid =3D find_ge_pid(iter.tid, ns);
> +	if (pid) {
> +		iter.tid =3D pid_nr_ns(pid, ns);
> +		iter.task =3D pid_task(pid, PIDTYPE_PID);
> +		/* As the tgid does not change during de_thread
> +		 * this test if a task is in a thread group
> +		 * should always be accurate.
> +		 */
> +		if (!iter.task || task_tgid(iter.task) !=3D tgid) {
> +			iter.tid +=3D 1;
> +			goto retry;
>  		}
> +		get_task_struct(iter.task);
>  	}
> -found:
> -	get_task_struct(pos);
> -out:
>  	rcu_read_unlock();
> -	return pos;
> +	return iter;
>  }
> =20
> -/*
> - * Find the next thread in the thread list.
> - * Return NULL if there is an error or no next thread.
> - *
> - * The reference to the input task_struct is released.
> - */
> -static struct task_struct *next_tid(struct task_struct *start)
> -{
> -	struct task_struct *pos =3D NULL;
> -	rcu_read_lock();
> -	if (pid_alive(start)) {
> -		pos =3D next_thread(start);
> -		if (thread_group_leader(pos))
> -			pos =3D NULL;
> -		else
> -			get_task_struct(pos);
> -	}
> -	rcu_read_unlock();
> -	put_task_struct(start);
> -	return pos;
> -}
> +#define TID_OFFSET 2
> =20
>  static int proc_task_fill_cache(struct file *filp, void *dirent, filldir=
_t filldir,
> -	struct task_struct *task, int tid)
> +	struct tid_iter iter)
>  {
>  	char name[PROC_NUMBUF];
> -	int len =3D snprintf(name, sizeof(name), "%d", tid);
> +	int len =3D snprintf(name, sizeof(name), "%d", iter.tid);
>  	return proc_fill_cache(filp, dirent, filldir, name, len,
> -				proc_task_instantiate, task, NULL);
> +				proc_task_instantiate, iter.task, NULL);
>  }
> =20
>  /* for the /proc/TGID/task/ directories */
> @@ -3061,24 +3033,22 @@ static int proc_task_readdir(struct file * filp, =
void * dirent, filldir_t filldi
>  {
>  	struct dentry *dentry =3D filp->f_path.dentry;
>  	struct inode *inode =3D dentry->d_inode;
> -	struct task_struct *leader =3D NULL;
> +	struct pid *tgid =3D NULL;
>  	struct task_struct *task;
>  	int retval =3D -ENOENT;
>  	ino_t ino;
> -	int tid;
> +	struct tid_iter iter;
>  	struct pid_namespace *ns;
> =20
>  	task =3D get_proc_task(inode);
>  	if (!task)
>  		goto out_no_task;
>  	rcu_read_lock();
> -	if (pid_alive(task)) {
> -		leader =3D task->group_leader;
> -		get_task_struct(leader);
> -	}
> +	if (pid_alive(task))
> +		tgid =3D get_pid(task_tgid(task));
>  	rcu_read_unlock();
>  	put_task_struct(task);
> -	if (!leader)
> +	if (!tgid)
>  		goto out_no_task;
>  	retval =3D 0;
> =20
> @@ -3097,26 +3067,21 @@ static int proc_task_readdir(struct file * filp, =
void * dirent, filldir_t filldi
>  		/* fall through */
>  	}
> =20
> -	/* f_version caches the tgid value that the last readdir call couldn't
> -	 * return. lseek aka telldir automagically resets f_version to 0.
> -	 */
>  	ns =3D filp->f_dentry->d_sb->s_fs_info;
> -	tid =3D (int)filp->f_version;
> -	filp->f_version =3D 0;
> -	for (task =3D first_tid(leader, tid, filp->f_pos - 2, ns);
> -	     task;
> -	     task =3D next_tid(task), filp->f_pos++) {
> -		tid =3D task_pid_nr_ns(task, ns);
> -		if (proc_task_fill_cache(filp, dirent, filldir, task, tid) < 0) {
> -			/* returning this tgid failed, save it as the first
> -			 * pid for the next readir call */
> -			filp->f_version =3D (u64)tid;
> +	iter.task =3D NULL;
> +	iter.tid =3D filp->f_pos - TID_OFFSET;
> +	for (iter =3D next_tid(ns, tgid, iter);
> +	     iter.task;
> +	     iter.tid +=3D 1, iter =3D next_tid(ns, tgid, iter)) {
> +		filp->f_pos =3D iter.tid + TID_OFFSET;
> +		if (proc_task_fill_cache(filp, dirent, filldir, iter) < 0) {
>  			put_task_struct(task);
> -			break;
> +			goto out;
>  		}
>  	}
> +	filp->f_pos =3D PID_MAX_LIMIT + TID_OFFSET;
>  out:
> -	put_task_struct(leader);
> +	put_pid(tgid);
>  out_no_task:
>  	return retval;
>  }
> --=20
> 1.6.1.2.350.g88cc
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-11534-1237384634-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJwP2+VKcRuvQ9Q1QRAkR2AJ40Y6yeAHStLUrnmJ+qqxqDfobohQCgpwRk
mSfRUZUU36lit6T/kayQFHI=
=H+mG
-----END PGP SIGNATURE-----

--=_bohort-11534-1237384634-0001-2--
