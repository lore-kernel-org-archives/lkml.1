Return-Path: <linux-kernel-owner+w=401wt.eu-S936064AbXHGXPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936064AbXHGXPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762469AbXHGXO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:14:57 -0400
Received: from smtp109.sbc.mail.re2.yahoo.com ([68.142.229.96]:41218 "HELO
	smtp109.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760368AbXHGXO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:14:56 -0400
X-YMail-OSG: 8oAM7jAVM1klneIivRX7JIoX9LFUx5iudtj7YIA1heVF6l6vq6mErcIEtO_.bjy72iMxXL4_7YW9AVq_t.DL3vRRWNEcpB4KDgm0o3Tn_e6yUkLwlvWtY2xp4XO8ZhdP_N4abPURBe4.ve4-
Date: Tue, 7 Aug 2007 18:14:52 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "Serge E. Hallyn" <sergeh@us.ibm.com>, Andrew Morgan <morgan@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: file capabilities: clear fcaps on inode change (v3)
Message-ID: <20070807231452.GA27198@vino.hallyn.com>
References: <20070807221727.GA12211@sergelap.austin.ibm.com> <1186526285.6625.41.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186526285.6625.41.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Trond Myklebust (trond.myklebust@fys.uio.no):
> On Tue, 2007-08-07 at 17:17 -0500, Serge E. Hallyn wrote:
> 
> > diff --git a/fs/splice.c b/fs/splice.c
> > index e36c003..2df95f3 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -827,6 +827,12 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
> >  	ssize_t ret;
> >  	int err;
> >  
> > +	mutex_lock(&inode->i_mutex);
> > +	err = security_inode_killpriv(out->f_path.dentry);
> > +	mutex_unlock(&inode->i_mutex);
> > +	if (err)
> > +		return err;
> 
> You are unconditionally taking the i_mutex whether or not you actually
> have any capabilities to remove. Normally, removing capabilities due to
> a write is something which occurs once every blue moon. Can't you
> introduce a heuristic along the lines of should_remove_suid() in order
> to optimise away the common case?

Yeah, I did that in v1, but didn't want to add two new security_ hooks.
But I'll send a v4 doing that.

> In addition, if you need to remove both the capabilities and the suid
> bits, then it should be unnecessary to take the i_mutex twice.

Good point, I'll consolidate those.

> > +
> >  	err = should_remove_suid(out->f_path.dentry);
> >  	if (unlikely(err)) {
> >  		mutex_lock(&inode->i_mutex);
> 
> Trond

thanks,
-serge
