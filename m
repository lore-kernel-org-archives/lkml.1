Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbYCEQ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbYCEQ6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbYCEQ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:58:26 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:37608 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbYCEQ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=VysbMJznH1a8PN2Xxez+GAw3zPB46rgL1RKMVIOodMgVuBqsHoWPfUJwxB6SwwKEbNWoZKZtNBkPKGqJS/A6uooJCgVNjcEa0rv84kitkvUZtioMW+nIWkmulcjCRZl4t5zhJX3jk++qCp5v/yCRnczH70A40Zcq5Vi7ZGMQtJw=
Date: Wed, 5 Mar 2008 18:55:13 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Paul Moore <paul.moore@hp.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH -v7 -rc3] Security: Introduce security= boot parameter
Message-ID: <20080305165513.GA26419@ubuntu>
References: <20080305152901.GA26016@ubuntu> <31708.65957.qm@web36611.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31708.65957.qm@web36611.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

On Wed, Mar 05, 2008 at 08:33:34AM -0800, Casey Schaufler wrote:
> 
> --- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> 
...
> > 
> > Do not let SMACK register smackfs if it was not chosen on
> > boot. Smackfs assumes that smack hooks are registered and
> > the initial task security setup (swapper->security) is done.
> 
> If the problem with initializing smackfs is because the
> locks aren't initialized why not leave the lock initializations
> in smack_init, and have them done before the check to see if the
> smack LSM is going to get used? Really, we're only talking
> about the case where a kernel is configured for testing or
> development purposes, and the lock initialization can't
> be considered a major impact in any case.
> 

Beside the locking initialization issue, there's the current->security
issue. smackfs init code code access current->security in 
smk_unlbl_ambient().

As you know current->security may equal Null (Oops), or point to 
another LSM structure that preceeded us in registration. 

The locking argument can't be applied here since we may override
the other LSM tsk->security pointer this time.

Ofcourse all of the above points can be handleded by various
if(current->security) checks + rechecking the read/write methods
of each smackfs inode, but below only two lines will fix the 
problem from its roots ;):

+	if (!security_module_enable(&smack_ops))
+		return 0;

Is there a problem in the current approach that I'm not aware of ?

You have your veto in this issue at the end ;)

Thank you,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

