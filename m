Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbXLKXEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbXLKXEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXLKXEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:04:22 -0500
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:25699 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753477AbXLKXEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:04:21 -0500
X-YMail-OSG: 7dMVGZoVM1m5F_GeYkRtbJmBP807w6U8WgiyEK7v8SPX94FfS4_dZHnJkni216RB.Q--
X-RocketYMMF: rancidfat
Date: Tue, 11 Dec 2007 15:04:16 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <12117.1197412980@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <81862.27432.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > All your code has to do is invoke a function provided by libselinux.
> 
> Calling libselinux means it's a special case for a specific LSM.
> 
> I think the best way to do this, then, has to be to dlopen the appropriate
> LSM
> library.  That way I don't need to do any conditional compilation or linking,
> but can build all the bits in to cachefilesd and have the appropriate one
> selected by the /etc/cachefilesd.conf.
> 
> So, what do I invoke in libselinux, how do I configure it, and how do I
> integrate the config into my RPM and install it?
> 
> And then what does it give me that I can hand to the kernel (a context string
> for SELinux, I presume), how do I get the kernel to make a check on it, how
> do
> I configure the check and how do I install that config from my RPM (I presume
> I just need to modify the .fc, .if and .te files that I have already)?

That seems like an awful lot of work. I suggest that what you
put in /etc/cachefilesd.conf is a line like:

   security_context:"<whatever>"

and have your daemon pass "<whatever>" into the kernel using
a cachefile mechanism. The kernel code can call
security_secctx_to_secid("<whatever>") to determine if it's valid.
No need to invoke LSM specific code in your daemon. You may need
to have an application, say cachefileselinuxcontext, that will
read the current policy and spit out an appropriate value of
"<whatever>", but that can be separate and LSM specific without
mucking up your basic infrastructure applications. 

> > That mostly works, but it means that an update to policy may require an
> > update to /etc/cachefilesd.conf, or that switching from one policy to
> > another might likewise require changing that file.  Versus using a
> > separate policy-provided config file for the label.
> 
> Whilst that's a fair point, if it's in a config file somewhere, then someone
> may want to change it or someone may want to provide a second file for a
> second cache with a different security label.
>
> > BTW, as should be obvious, some LSMs aren't label-based at all, so it
> > would need to be optional.
> 
> Aargh.  In which case it might not be possible to make the SELinux context
> passing from userspace -> kernel generic for all LSMs:-(

For LSM's that don't use labels what you will have to pass in
won't be a label, it will be something else. But since any LSM
that wants to do networking or audit will have to deal with
secid's and secctx's the method outlined above ought to fit the
bill.



Casey Schaufler
casey@schaufler-ca.com
