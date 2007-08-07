Return-Path: <linux-kernel-owner+w=401wt.eu-S934675AbXHGNsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934675AbXHGNsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763143AbXHGNr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:47:59 -0400
Received: from namei.org ([69.55.235.186]:46868 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758204AbXHGNr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:47:58 -0400
X-Greylist: delayed 1447 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 09:47:58 EDT
Date: Tue, 7 Aug 2007 06:47:16 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
In-Reply-To: <20070806185231.GA21550@sergelap.austin.ibm.com>
Message-ID: <Pine.LNX.4.64.0708070640160.31104@us.intercode.com.au>
References: <20070806185231.GA21550@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Serge E. Hallyn wrote:

> +	err = security_inode_killpriv(out->f_path.dentry, LSM_NEED_LOCK);
> +	if (err)
> +		return err;
> +
>  	err = should_remove_suid(out->f_path.dentry);
>  	if (unlikely(err)) {
>  		mutex_lock(&inode->i_mutex);

It seems hackish to pass a needlock arg to an API, and that that we'll end 
up with some conceptually similar call-outs for both caps and setuid.

How about encapsulating this stuff so that there's something like:


	err = should_remove_privs();
	if (err)
		remove_privs();

with

void remove_privs()
{
	mutex_lock();
	__remove_privs();
	mutex_unlock();
}

and then __remove_privs() handles the logic for all file privileges, 
including at this stage suid and the LSM call for file caps ?



- James
-- 
James Morris
<jmorris@namei.org>
