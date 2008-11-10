Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYKJQvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYKJQvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYKJQvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:51:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:52426 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbYKJQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:51:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p0i7uS6Wgus+MltbRzwEnIC1hoo/x51Zuxjq5UehF7roMOF9f7QcqhWdzY+j2W9lJM
         iN433jSD26SmK6FQuDg8AvmEwPfjEo8Xk8i8BVW0/1QG4qawa3Yoq9QErH4G+UgOWxmi
         JuUSQreQ446Ir10p1ifOIH+MIVJuHyximTKM0=
Subject: Re: [RFC-PATCH 1/5] unaligned: introduce common header
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <87a5b0800811100349n435785by27ebc4e495bb7985@mail.gmail.com>
References: <1225908976.5991.180.camel@brick>
	 <87a5b0800811080447m2cebebb7j77afe9592f72ab11@mail.gmail.com>
	 <1226290940.5478.3.camel@brick>
	 <87a5b0800811100349n435785by27ebc4e495bb7985@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 08:51:29 -0800
Message-Id: <1226335889.5478.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 11:49 +0000, Will Newton wrote:
> On Mon, Nov 10, 2008 at 4:22 AM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> 
> (add back lkml cc that I mistakenly dropped)
> 
> > On Sat, 2008-11-08 at 12:47 +0000, Will Newton wrote:
> >> On Wed, Nov 5, 2008 at 6:16 PM, Harvey Harrison
> >> <harvey.harrison@gmail.com> wrote:
> >>
> >> > The memmove-based arches (m32r, xtensa, h8300) are likely going to be fine with this change
> >> > barring compiler bugs that made them go with memmove in the first place.
> >>
> >> As I understand it the need for the memmove implementation is not
> >> compiler bugs but default struct alignment. The packed struct
> >> implementation will only work with compilers where structs can be
> >> aligned on byte boundaries, it's fairly common for RISC architectures
> >> to align structs to 4 or 8 byte boundaries.
> >
> > Which I believe is disabled entirely using __attribute__((packed)), no?
> 
> As far as I am aware the packed attribute is handled in this way for
> some toolchains (arm in particular). Not everybody does it, and for
> good reasons. For example if I have this struct on an architecture
> with 8 byte default struct alignment:
> 

I should have been more careful with my wording here, I meant that no
alignment assumptions are made when accessing a packed struct through
a pointer, as is the case with the kernel version.

> struct foo {
>     u64 big_data;
>     u8 small_data;
>     u32 medium_data;
> } __attribute__((packed));
> 
> Should big_data be accessed as 8 byte load instructions rather than
> one 64bit load instruction? It's a pretty large performance penalty to
> pay when all I really want is for medium_data to be accessed
> correctly.

In this particular case, packed isn't right as you know big_data is
aligned (as long as you can guarantee the struct alignment), so you'd
probably want:

struct foo {
	u64 big_data;
	u8 small_data;
	u32 medium_data __attribute__((__packed__));
}

But that's not what we're talking about in the kernel's case.

Harvey

