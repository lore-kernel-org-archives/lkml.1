Return-Path: <linux-kernel-owner+w=401wt.eu-S1760407AbYCUSSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407AbYCUSSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYCUSSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:18:03 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:48682 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754028AbYCUSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:18:00 -0400
X-YMail-OSG: B8tUvYEVM1lyR3kIkmm57_PSWbG9ND7py1QQb8Vd.bxHikflxhrOBGL3d.In7kdZ9sxBnB_pRdF0kylQy5bEjbNdcWrwsanpYWOQT6g5zx5N.QBzS.ukCfnGyKLrhS4gnkSpTClfIrLevkHmLD.AIQ--
X-RocketYMMF: rancidfat
Date: Fri, 21 Mar 2008 11:17:51 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH BUGFIX -rc6] Smackfs: remove redundant lock, fix open(,O_RDWR)
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
In-Reply-To: <20080321150541.GA19083@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <229474.71421.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi all,
> 
> Older smackfs was parsing MAC rules by characters, thus a need of
> locking write sessions on open() was needed. This lock is no longer
> useful now since each rule is handled by a single write() call.
> 
> This is also a bugfix since seq_open() was not called if an open()
> O_RDWR flag was given, leading to a seq_read() without an initialized
> seq_file, thus an Oops.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> Reported-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> --
> 
>  security/smack/smackfs.c |   35 ++---------------------------------
>  1 file changed, 2 insertions(+), 33 deletions(-)
> 
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index afe7c9b..cfae8af 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -74,11 +74,6 @@ struct smk_list_entry *smack_list;
>  #define	SEQ_READ_FINISHED	1
>  
>  /*
> - * Disable concurrent writing open() operations
> - */
> -static struct semaphore smack_write_sem;
> -
> -/*
>   * Values for parsing cipso rules
>   * SMK_DIGITLEN: Length of a digit field in a rule.
>   * SMK_CIPSOMIN: Minimum possible cipso rule length.
> @@ -168,32 +163,7 @@ static struct seq_operations load_seq_ops = {
>   */
>  static int smk_open_load(struct inode *inode, struct file *file)
>  {
> -	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
> -		return seq_open(file, &load_seq_ops);
> -
> -	if (down_interruptible(&smack_write_sem))
> -		return -ERESTARTSYS;
> -
> -	return 0;
> -}
> -
> -/**
> - * smk_release_load - release() for /smack/load
> - * @inode: inode structure representing file
> - * @file: "load" file pointer
> - *
> - * For a reading session, use the seq_file release
> - * implementation.
> - * Otherwise, we are at the end of a writing session so
> - * clean everything up.
> - */
> -static int smk_release_load(struct inode *inode, struct file *file)
> -{
> -	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
> -		return seq_release(inode, file);
> -
> -	up(&smack_write_sem);
> -	return 0;
> +	return seq_open(file, &load_seq_ops);
>  }
>  
>  /**
> @@ -341,7 +311,7 @@ static const struct file_operations smk_load_ops = {
>  	.read		= seq_read,
>  	.llseek         = seq_lseek,
>  	.write		= smk_write_load,
> -	.release        = smk_release_load,
> +	.release        = seq_release,
>  };
>  
>  /**
> @@ -1011,7 +981,6 @@ static int __init init_smk_fs(void)
>  		}
>  	}
>  
> -	sema_init(&smack_write_sem, 1);
>  	smk_cipso_doi();
>  	smk_unlbl_ambient(NULL);
>  
> Regards,
> 
> -- 
> 
> "Better to light a candle, than curse the darkness"
> 
> Ahmed S. Darwish
> Homepage: http://darwish.07.googlepages.com
> Blog: http://darwish-07.blogspot.com
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
