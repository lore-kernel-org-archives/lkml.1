Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbYKJSw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbYKJSw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYKJSwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:52:50 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:21908 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYKJSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:52:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QYGcleTIHCI1qGWpJsCvDEZDr4kRUJLHQfjS8E6gsXeuT0hz+cpWvNh008heoYHMfY
         sWUyaL37wSpy6scp24XY21tSWv0BuQ55ixMlNH2id2Kp4NoYAzbew6roH+hBA2AdVFv0
         CY9n4FXboqIvmrs8RwOxnrAdSKTqTghcHVzqM=
Subject: Re: [RFC-PATCH 1/5] unaligned: introduce common header
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <87a5b0800811101035i721f1befi79ff76f9169fef4c@mail.gmail.com>
References: <1225908976.5991.180.camel@brick>
	 <87a5b0800811080447m2cebebb7j77afe9592f72ab11@mail.gmail.com>
	 <1226290940.5478.3.camel@brick>
	 <87a5b0800811100349n435785by27ebc4e495bb7985@mail.gmail.com>
	 <1226335889.5478.40.camel@brick>
	 <87a5b0800811101035i721f1befi79ff76f9169fef4c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Nov 2008 10:51:24 -0800
Message-Id: <1226343084.22742.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 18:35 +0000, Will Newton wrote:
> On Mon, Nov 10, 2008 at 4:51 PM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> >
> > In this particular case, packed isn't right as you know big_data is
> > aligned (as long as you can guarantee the struct alignment), so you'd
> > probably want:
> >
> > struct foo {
> >        u64 big_data;
> >        u8 small_data;
> >        u32 medium_data __attribute__((__packed__));
> > }
> >
> > But that's not what we're talking about in the kernel's case.
> 
> Perhaps that would be a neater way of expressing what is required in
> my simple example, but it's fairly common to use packed on the whole
> struct which could be because a field that is "packed" by default on
> one architecture might not be on another. You could mark every field
> as packed but few people seem to do that and as far as I am aware
> there is no documented difference between packing all members and the
> whole struct. The gcc documentation for packed is pretty short:

Actually it's documented that putting attribute(packed) on the struct
is equivalent to putting attribute(packed) on _every_ member of the
struct.

>   The packed attribute specifies that a variable or structure field
> should have the smallest
>   possible alignment—one byte for a variable, and one bit for a field,
> unless you specify a
>   larger value with the aligned attribute.
> 
> I'd love to know if the pointer alignment behaviour is widespread and
> then maybe write a patch for the gcc manual.

Well, it's kind of the whole point of __packed isn't it?  Otherwise the
struct members get naturally (or some arch-dependent value) aligned,
which the compiler can rely on unless you say __packed.

So in my example above, the compiler _knows_ how it has aligned
big_data and small_data and can use whatever access is most efficient,
but it can't make any assumptions about medium_data, so access through
a pointer _must_ be done unaligned.

struct foo *bar;
bar->medium_data; // compiler must do this unaligned

Harvey

