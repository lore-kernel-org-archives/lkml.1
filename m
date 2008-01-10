Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYAJBGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYAJBGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbYAJBGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:06:30 -0500
Received: from neon.samage.net ([85.17.153.66]:35497 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757795AbYAJBG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:06:28 -0500
Message-ID: <45870.81.207.0.53.1199927182.squirrel@secure.samage.net>
In-Reply-To: <20080109230853.GA26627@sergelap.austin.rr.com>
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
    <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
    <20080106062609.GC20753@1wt.eu>
    <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp>
    <51953.81.207.0.53.1199738255.squirrel@secure.samage.net>
    <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp>
    <45796.81.207.0.53.1199807221.squirrel@secure.samage.net>
    <200801090439.m094d267092095@www262.sakura.ne.jp>
    <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
    <20080109230853.GA26627@sergelap.austin.rr.com>
Date: Thu, 10 Jan 2008 02:06:22 +0100 (CET)
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: "Indan Zupancic" <indan@nul.nu>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: bc82d6a2e188773012c482ed32290af0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 10, 2008 00:08, Serge E. Hallyn wrote:
> These emails again are getting really long, but I think the gist of
> Indan's suggestion can be concisely summarized:

No worry, I wasn't planning on extending it, I've said what I've to say.

Except...

>
> 	"To confine process P3 to /dev/hda2 being 'b 3 2', create
> 	/dev/p3, launch P3 in a new mounts namespace, mount --bind
> 	/dev/p3 /dev, exec what you want p3 running, and have
> 	MAC prevent umount /dev/p3."
>
> This is a neat idea, but Tetsuo's rebutall is
>
> 	"P3 may be legacy code needing to create or delete
> 	/dev/floppy, where -EPERM confuses P3 and prevents
> 	it working correctly."
>
> Indan's idea is interesting and I like it, but is there an answer to
> Tetsuo's problem with it?

...that I didn't mean that, but a more simple

/dev/ directory protected from any modifications by MAC,

/dev/* all the nodes that need to have guaranteed name/attribute pairs,
    like /dev/null, /dev/zero, /dev/random, etc. and:

/dev/dynamic/ being a dir where apps who really need to create/modify
    device nodes can do whatever they want to do. It can be multiple dirs
    too, like /dev/snd/, /dev/input/ etc.

I guess this covers about 96% of the usecases of this tamper-proof dev fs.

You can think of unlikely cases that aren't solved by this, but those can
be solved in another way if really wanted (like a checking daemon,
modified udev, shadow /dev/, to name a few).

But I think doing more is getting ridiculous, because if a process can
create a device node, it can also access it and do whatever harm could
be done by the confusion caused by unexpected name/attribute pairs.

As for information snooping, that's mostly about /dev/null or other
things that are known beforehand.

> PS - Indan, you also said in essence "if P3 can be trusted to create
> /dev/floppy why can't it be trusted to create /dev/hda1".  I trust that,
> phrased that way, the question answers itself?

Not exactly. If there's a process that dynamically created certain device
nodes, and it wants to create one that doesn't fit the rules, you can't
know if it's wrong or if your rules are wrong. The process has a certain
policy of naming/creating the devices, but you also have a policy at the
kernel side with this fs. If it mismatches you don't know which one is
right.

If you trust a process to create /dev/hd*, you can also trust it to create
the proper /dev/hdXn, no need to verify if /dev/hda1 is really 3 1.

The whole thing about filename/attribute pairs is that it's about what
applications expect. There aren't many expectations about dynamically
created device nodes which might not always be there, because their
name isn't stable.

The use case for this fs is a malicious app that can create device nodes,
and we're worried about mismatching name/attribute pairs. Not about
our data, or anything else. Call me an optimist, but I think you don't
need to worry about name/attribute pairs.

Greetings,

Indan


