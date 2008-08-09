Return-Path: <linux-kernel-owner+w=401wt.eu-S1751809AbYHIJsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbYHIJsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 05:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYHIJsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 05:48:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:46135 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYHIJsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 05:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f5SCpYyuP29TK0Z3o2LdXjI33poBfgLisxM/zOdSy/cSIEUxKXJQN22am6XMw2eR4n
         qN40CF7wieBvd9P+kqN/QOboi5b9IT9WEnBBo8NVjXHyEFm+W4sURLDqcKVp5YU9RifH
         VdiHgAEe3pdBiIsC2rE++TUo9hvcuAUqeEXK4=
Message-ID: <863e9df20808090248h3adc2ac3mdb3217fe2876ab3b@mail.gmail.com>
Date: Sat, 9 Aug 2008 15:18:14 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Roland McGrath" <roland@redhat.com>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       "Clark Williams" <williams@redhat.com>
In-Reply-To: <20080807182013.984175558@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080807182013.984175558@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 11:50 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> You see, the reason for this is that for ftrace to maintain performance
> when configured in but disabled, it would need to change all the
> locations that called "mcount" (enabled with the gcc -pg option) into
> nops.  The "-pg" option in gcc sets up a function profiler to call this
> function called "mcount". If you simply have "mcount" return, it will
> still add 15 to 18% overhead in performance. Changing all the calls to
> nops moved the overhead into noise.
>
> To get rid of this, I had the mcount code record the location that called
> it. Later, the "ftraced" daemon would wake up and look to see if
> any new functions were recorded. If so, it would call kstop_machine
> and convert the calls to "nops". We needed kstop_machine because bad
> things happen on SMP if you modify code that happens to be in the
> instruction cache of another CPU.

Is this new framework needed for x86 specific reasons only? From what
I gathered here, ftraced defers mcount patching simply because there's
no way to update a 5-byte nop atomically. If so, why can't mcount site
patching be left to arch specific ftrace code? For !SMP or archs which
generate word sized mcount branch calls (e.g, ARM) is there really no
way to patch  mcount sites synchronously from inside ftrace_record_ip
by disabling interrupts?

Regards,
Abhishek Sagar
