Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbYBNECm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbYBNECm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 23:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYBNECd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 23:02:33 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:12058 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYBNECc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 23:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JMp5FO0HIdDQU9uN6T/vNDblz4hhvULA3za6kNp7Z7eEXdVIMFtkYMNLO1M7MnTVago0ECK/qOrxjYj3EFBGFzwNVkNB8YHcc1ZynMCPGfOVG/pzz20PJyZjXNbJYMeE2QTNsoSWLsKzvIEEzfnqK2HoPR/xmddsFHjlX1sOAuM=
Message-ID: <47B3BD51.1080706@gmail.com>
Date: Thu, 14 Feb 2008 13:02:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
References: <47ABC08C.8010101@qualcomm.com>
In-Reply-To: <47ABC08C.8010101@qualcomm.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Max.

Max Krasnyansky wrote:
> I was hopping you could answer a couple of questions about module loading/unloading
> and the stop machine.
> There was a recent discussion on LKML about CPU isolation patches I'm working on.
> One of the patches makes stop machine ignore the isolated CPUs. People of course had
> questions about that. So I started looking into more details and got this silly, crazy 
> idea that maybe we do not need the stop machine any more :)
> 
> As far as I can tell the stop machine is basically a safety net in case some locking
> and recounting mechanisms aren't bullet proof. In other words if a subsystem can actually
> handle registration/unregistration in a robust way, module loader/unloader does not 
> necessarily have to halt entire machine in order to load/unload a module that belongs
> to that subsystem. I may of course be completely wrong on that.

Nope, it's integral part of module reference counting.  When using
refcnt for object lifetime management, the last put should be atomic
against initial get of the object.  This is usually achieved by
acquiring the lock used for object lookup before putting or using
atomic_dec_and_lock().

For module reference counts, this means that try_module_get() and
try_stop_module() should be atomic.  Note that modules don't use simple
refcnt so the latter part isn't module_put() but the analogy still
works.  There are two ways to synchronize try_module_get() against
try_stop_module() - the traditional is to grab lock in try_module_get()
and use atomic_dec_and_lock() in try_stop_module(), which works but
performance-wise bad because try_module_get() is used way much more than
try_stop_module() is.  For example, an IO command can go through several
try_module_get()'s.

So, all the burden of synchronization is put onto try_stop_module().
Because all of the cpus on the machine are stopped and none of them has
been stopped in the middle of non-preemptible code, __try_stop_module()
is synchronized from try_module_get() even though all the
synchronization try_module_get() does is get_cpu().

> The problem with the stop machine is that it's a very very big gun :). In a sense that 
> it totally kills all the latencies and stuff since the entire machine gets halted while
> module is being (un)loaded. Which is a major issue for any realtime apps. Specifically 
> for CPU isolation the issue is that high-priority rt user-space thread prevents stop 
> machine threads from running and entire box just hangs waiting for it. 
> I'm kind of surprised that folks who use monster boxes with over 100 CPUs have not 
> complained. It's must be a huge hit for those machines to halt the entire thing. 
> 
> It seems that over the last few years most subsystems got much better at locking and 
> refcounting. And I'm hopping that we can avoid halting the entire machine these days.
> For CPU isolation in particular the solution is simple. We can just ignore isolated CPUs. 
> What I'm trying to figure out is how safe it is and whether we can avoid full halt 
> altogether.

Without the stop_machine call, there's no synchronization between
initial get and final put.  Things will break.

Thanks.

-- 
tejun
