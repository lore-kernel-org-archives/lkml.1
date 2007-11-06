Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbXKFX7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbXKFX7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbXKFX7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:59:23 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:37861 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbXKFX7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:59:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yn1jya0e2+DOQm01gh6RPY8IFCERsfKCyenw0gvAPbKgiofl0X0bSPQfA9r4YIv9OFN4IlkkK6r9sDdKFnrROhiD94ah9qbGPAfrhVMHOUW6E2ZABJ6ns+kOkoZpIPm4ZAtNNpcVdhUVz1DNn33YQuEXm2223Lt2lLWl1tgDVA4=
Message-ID: <e7d8f83e0711061559l26ff4d27gc97f809af6d8b979@mail.gmail.com>
Date: Wed, 7 Nov 2007 09:59:20 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: Cliffe <cliffe@ii.net>
Subject: Re: Defense in depth: LSM *modules*, not a static interface
Cc: "Crispin Cowan" <crispin@crispincowan.com>,
       "Simon Arlott" <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <47301739.3010604@ii.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
	 <4726377A.4080807@crispincowan.com>
	 <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
	 <4726D9D9.2000909@ii.net> <29685.simon.1193747418@5ec7c279.invalid>
	 <472FE383.70103@crispincowan.com> <47301739.3010604@ii.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lets on paper do what Crispin Cowan said to be a good stacker apparmor
become purely restrictive and modules like it.  This will explain were
stacking ends up dead meat.

Most people don't notice that the default system is there Posix
Capabilities.   So effectively just by changing apparmor you have now
double layered the code.   Effectively slower.

Stacking risks creating a longer and longer path to permit and refuse
a request.  Since modules cannot take advantage of system provided
parts.  Without dealing with that problem stacking is a speed problem
as well as a security one.

I know a strange question would the be a advantage in adding a set of
restrictive options to POSIX.1e Capabilities section.  Could this
reduce the overall amount of code making up LSM's.  Might cure the
depth problem of stacking most of the time.  Less traveling threw the
LSMs less problems on speed.. And reduce the numbers of hooks needed
by LSM's into kernel.

I agree with Crispin Cowan at moment some modules are not stackable.
But there is a large price to pay by making them stackable too.  With
modules that are permissive and restrictive I have never come up a
good solution in Crispin Cowan eyes.  Its the reason why I was
splitting the security into zones.  It was the only way I could come
up with to make sure they could not fight.  Give them each there own
limited domain of control with limited permissions on offer.

Depth of stacking is important from admin point of view.  Ok something
coders can simply forget.  Lets say I have a application not working
due to secuirty on a linux I have never used before.  Yes this happens
when you replace admins.   Stacked also risks giving me more configs
to look threw to find the file that is blocking.

Yes I agree with layering security.  But there comes a point were
complexly removes gain of layering.

"AppArmor profile denies all network traffic to a specific
application"  Ok why should AppArmor be required to do this.  Would it
not be better as as part of Capabilities that is always there and is
application controllable.  It would be a security advantage if data
processing threads that don't do network access inside a application
don't have it.  Basically this feature could be done in mirror.  Allow
Network access Capabilities flag.  Not set application cannot access
network at all.  All LSM's would be able to use that to cut of network
access to applications.  As a standard feature of kernel if a new
network stack or some other alteration is done LSM hooks would not
need altering.  Lot of LSM hooks would disappear.  Need for LSM to
monitor and run different code to kernel in a lot of places would also
disappear.

With Capabilities expand it to point that applications cannot do
anything without permissions.  Both models are do able.  Restrictive
can be done in a Permissive model effectively if the starting point of
the Permissive is that you cannot do anything without permissions
being granted.  Big different is that the Permissive Model is the
kernel default.  Some LSM are design in conflict with the main model
of the OS.  You really only want one model from speed point of view.

This is the main problem with LSM most are forcing self against grain
of the OS's design.  Needing lots of hooks into different places
should have been a big hint. You are ending up with 2 models where you
should have only one.  Ie permissive controlled can do a MAC just as
effectively as hooking everywhere in kernel.   To be correct is a lot
safer since applications would be able to drop there permissions as
needed.  LSM rootkit gets massive amounts of power at moment not by
breaking anything because everything is piped in its direction.  What
is the point of layers when there a layer that can do what ever it
sees fit.

Basically look at the main kernel design work with it don't fight with
it.   This will reduce code everyone needs.

Only effective way I can come up with of layering and not having one
layer grant something that another has taken away/change.  Is to
double up  posix capability and other security appling systems.  One
containing the final output and one to list was is still allowed to be
changed.   This is going to have a speed cost.  Thank god only the
final output needs to be entering kernel processing. Once something is
removed from being setable the next LSM along cannot change it and
should send a error message.   This still requires building a
completely common core security engine so that a LSM does not do a
feature outside so we don't have grant and forbid fights any more.

Only different to my container model is depth of travel.  This one
will be slower than Container model I was putting up before.

Note a engine to do security can be basically security module neutral.
 Yes at least we don't need to debate about if the engine should be
permissive or restrictive.  Since the engine already exists.
Permissive it is.  Fighting with existing design is wasting time.

Peter Dolding
