Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbYB1BLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbYB1BLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932072AbYB1BLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:11:22 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:46473 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758837AbYB1BLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:11:21 -0500
X-Greylist: delayed 2081 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 20:11:21 EST
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <822822.4853.qm@web36614.mail.mud.yahoo.com>
References: <822822.4853.qm@web36614.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 19:12:19 -0500
Message-Id: <1204157539.24345.3.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 15:42 -0800, Casey Schaufler wrote:
> --- "David P. Quigley" <dpquigl@tycho.nsa.gov> wrote:
> 
> > Before the inode_xattr_getsecurity call was removed the caller would
> > concatenate the security namespace prefix and the suffix provided by the lsm
> > to
> > obtain the security xattr. This hook provides the functionality to obtain the
> > full
> > LSM xattr name. The patch also provides implementations for the dummy
> > security
> > module and SELinux. This method is used instead of restoring the old method
> > since it only requires an offset into the returned pointer to obtain the
> > suffix. This approach is more efficient than concatenating the security xattr
> > namespace string with the suffix to get a usable string.
> > 
> > Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> > ---
> >  include/linux/security.h |    8 ++++++++
> >  security/dummy.c         |    6 ++++++
> >  security/security.c      |    6 ++++++
> >  security/selinux/hooks.c |   10 ++++++++--
> >  4 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index fe52cde..c80bee4 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -1394,6 +1394,7 @@ struct security_operations {
> >  	int (*secid_to_secctx)(u32 secid, char **secdata, u32 *seclen);
> >  	int (*secctx_to_secid)(char *secdata, u32 seclen, u32 *secid);
> >  	void (*release_secctx)(char *secdata, u32 seclen);
> > +	const char *(*maclabel_getname) (void);
> 
> I think that calling this a maclabel is a really bad idea. For one
> thing, it assumes that all interesting security attributes are for
> Mandatory Access Control. Also, it assumes that they are stored as
> xattrs. While these conditions are both met by the two current LSMs
> I would suggest that this is not a fair assumption for the long
> haul unless the intention is to lock the lSM into only supporting
> xattr based label based MAC modules.

Actually that is a completely fair assumption. When this whole thing
started it was mandated that security attributes be stored in xattrs. I
originally had a more convoluted name but after asking around we thought
this one was better. Not to mention this is a slightly reworked hook
that was just removed from the LSM since there were no users. While I'm
open to potentially changing the name the paradigm that we use the xattr
functionality of linux to handle security labels has been around since
the beginning of LSM. If we want to revisit that idea I'm willing to do
it but it needs more people than just you and I to agree to reopen it. 

> 
> If you are only interested in supporting one LSM then the code should
> go into that LSM specific code, not the LSM proper.
>   
> >  #ifdef CONFIG_SECURITY_NETWORK
> >  	int (*unix_stream_connect) (struct socket * sock,
> > @@ -1633,6 +1634,7 @@ int security_netlink_recv(struct sk_buff *skb, int
> > cap);
> >  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
> >  int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid);
> >  void security_release_secctx(char *secdata, u32 seclen);
> > +const char *security_maclabel_getname(void);
> >  
> >  #else /* CONFIG_SECURITY */
> >  
> > @@ -2316,6 +2318,12 @@ static inline int security_secctx_to_secid(char
> > *secdata,
> >  static inline void security_release_secctx(char *secdata, u32 seclen)
> >  {
> >  }
> > +
> > +static inline const char *security_maclabel_getname(void)
> > +{
> > +	return NULL;
> > +}
> > +
> >  #endif	/* CONFIG_SECURITY */
> >  
> >  #ifdef CONFIG_SECURITY_NETWORK
> > diff --git a/security/dummy.c b/security/dummy.c
> > index 649326b..928ef41 100644
> > --- a/security/dummy.c
> > +++ b/security/dummy.c
> > @@ -960,6 +960,11 @@ static void dummy_release_secctx(char *secdata, u32
> > seclen)
> >  {
> >  }
> >  
> > +static const char *dummy_maclabel_getname(void)
> > +{
> > +	return NULL;
> > +}
> > +
> >  #ifdef CONFIG_KEYS
> >  static inline int dummy_key_alloc(struct key *key, struct task_struct *ctx,
> >  				  unsigned long flags)
> > @@ -1118,6 +1123,7 @@ void security_fixup_ops (struct security_operations
> > *ops)
> >   	set_to_dummy_if_null(ops, secid_to_secctx);
> >  	set_to_dummy_if_null(ops, secctx_to_secid);
> >   	set_to_dummy_if_null(ops, release_secctx);
> > +	set_to_dummy_if_null(ops, maclabel_getname);
> >  #ifdef CONFIG_SECURITY_NETWORK
> >  	set_to_dummy_if_null(ops, unix_stream_connect);
> >  	set_to_dummy_if_null(ops, unix_may_send);
> > diff --git a/security/security.c b/security/security.c
> > index d15e56c..1a84eb1 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -845,6 +845,12 @@ void security_release_secctx(char *secdata, u32 seclen)
> >  }
> >  EXPORT_SYMBOL(security_release_secctx);
> >  
> > +const char *security_maclabel_getname(void)
> > +{
> > +	return security_ops->maclabel_getname();
> > +}
> > +EXPORT_SYMBOL(security_maclabel_getname);
> > +
> >  #ifdef CONFIG_SECURITY_NETWORK
> >  
> >  int security_unix_stream_connect(struct socket *sock, struct socket *other,
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 75c2e99..e7fc9c9 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -5163,6 +5163,11 @@ static void selinux_release_secctx(char *secdata, u32
> > seclen)
> >  	kfree(secdata);
> >  }
> >  
> > +static const char *selinux_maclabel_getname(void)
> > +{
> > +      return XATTR_NAME_SELINUX;
> > +}
> > +
> >  #ifdef CONFIG_KEYS
> >  
> >  static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
> > @@ -5351,8 +5356,9 @@ static struct security_operations selinux_ops = {
> >  	.secid_to_secctx =		selinux_secid_to_secctx,
> >  	.secctx_to_secid =		selinux_secctx_to_secid,
> >  	.release_secctx =		selinux_release_secctx,
> > -
> > -        .unix_stream_connect =		selinux_socket_unix_stream_connect,
> > +	.maclabel_getname =  		selinux_maclabel_getname,
> > +        
> > +	.unix_stream_connect =		selinux_socket_unix_stream_connect,
> >  	.unix_may_send =		selinux_socket_unix_may_send,
> >  
> >  	.socket_create =		selinux_socket_create,
> > -- 
> > 1.5.3.8
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> > 
> 
> 
> Casey Schaufler
> casey@schaufler-ca.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

