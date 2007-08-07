Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbXHGOIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbXHGOIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbXHGOIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:08:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46564 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbXHGOIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:08:30 -0400
Date: Tue, 7 Aug 2007 09:08:27 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
Message-ID: <20070807140827.GB8286@sergelap.austin.ibm.com>
References: <20070806185231.GA21550@sergelap.austin.ibm.com> <Pine.LNX.4.64.0708070640160.31104@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708070640160.31104@us.intercode.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Mon, 6 Aug 2007, Serge E. Hallyn wrote:
> 
> > +	err = security_inode_killpriv(out->f_path.dentry, LSM_NEED_LOCK);
> > +	if (err)
> > +		return err;
> > +
> >  	err = should_remove_suid(out->f_path.dentry);
> >  	if (unlikely(err)) {
> >  		mutex_lock(&inode->i_mutex);
> 
> It seems hackish to pass a needlock arg to an API, and that that we'll end 
> up with some conceptually similar call-outs for both caps and setuid.
> 
> How about encapsulating this stuff so that there's something like:
> 
> 
> 	err = should_remove_privs();
> 	if (err)
> 		remove_privs();
> 
> with
> 
> void remove_privs()
> {
> 	mutex_lock();
> 	__remove_privs();
> 	mutex_unlock();
> }
> 
> and then __remove_privs() handles the logic for all file privileges, 
> including at this stage suid and the LSM call for file caps ?

The problem is that the suid bit is not removed in all cases
when the file caps need to be removed.  In particular, if
capable(CAP_FSETID), then the suid bit is retained.

I suppose we could change those semantics, but then we'd the code still
doesn't flow quite right for what you suggest - should_remove_suid()
just checks whether the suid bit is set (and the process is !capable(CAP_FSETID),
not whether a change has happened requiring suid change.  That is
already assumed to be the case.

If your main objection is to the LSM_NEED_LOCK argument, we could of
course just grab the mutex around security_inode_killpriv(out->f_path.dentry)
in fs/splice.c:generic_file_splice_write().

And I suppose we can in fact get rid of ATTR_KILL_PRIV.  I had just
put it there to split up the code a bit to make it clearer - which I
do think it does.

Shall I resend without the LSM_NEED_LOCK, or do you still want a more
fundamental change?

thanks,
-serge
