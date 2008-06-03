Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYFCENS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYFCENS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYFCENI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:13:08 -0400
Received: from hs-out-0708.google.com ([64.233.178.250]:60308 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYFCENG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:13:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mL6Xd5qS+LGmkfyGJ4bWr565NLKZdkusVigfUcI/H7F8bVYw0P2MmXnBMk7e5qNbLegy7yL6U9CniVTaX8/SFRHceYWdrkHtlOCaVh1IUyXOBSnDCNu6YEflKg5Z9NycnQe0N77hHZLsLdMBKTZ8xE9nvF9t/b4Jdlruf9qEJZE=
Message-ID: <863e9df20806022113w339257b1pa4c8a7762bab8bc1@mail.gmail.com>
Date: Tue, 3 Jun 2008 09:43:05 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/3][RFC] ftrace: track dynamic ftrace update failures
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0806021354520.10366@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4842CB8F.2000702@gmail.com>
	 <Pine.LNX.4.58.0806021354520.10366@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 11:26 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Hi Abhishek,

Hi Steven,

Thanks for reviewing my recent patches.

> Have you also taken into account adding and removing of modules? This can
> cause some funny behaviours with ftrace that can be rather dangerous.

I've tried to accommodate them (fixed the wrong use of
kernel_text_address). This makes
init and module function records eligible to be freed. Only core
kernel function update failures now get tracked/remembered.

There might still be a need to find a way to track external modifiers
of mcount call-sites such as (but not limited to) kprobes. Consider
this (rather long) contrived scenario:

1. Function foo gets recorded by ftrace.
2. Mcount call site of foo is patched with a NOP by ftraced.
3. foo gets 'enabled' by some ftrace filter rule. NOP changes to a
call to the function tracer.
4. A kprobe is registered on the mcount call-site. It places a trap
generating instruction at the
mcount call site and stores the call-to-function-tracer instruction
elsewhere internally.
5. Tracing is disabled by end user.
6. Disabling of foo fails because Kprobe had placed a trap at the
mcount call site.
7. foo still keeps getting traced because Kprobes will keep
single-stepping the call-to-function-tracer instruction each time the
mcount call site is executed.

Not sure what to do with such cases...

--
Regards,
Abhishek Sagar
