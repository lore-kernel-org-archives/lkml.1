Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYKKJvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYKKJvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbYKKJu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:50:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:49171 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbYKKJu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:50:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xsq1e6QOXWFezb3lgUk/8RwwHoYk2ShtMVLU9M/Ng5YRyx+wU+BWA7xL/9D3nrv7nT
         UM3/wFxYBCoC7kph0M8Wewa49aITI2eQWQUcoq3VCpndQ92wIe1Xlhx0QdEnP00bYPxe
         3W9g9G0nRmLchOI9IXqpoa9k0dLkPd3DbkZtA=
Message-ID: <87a5b0800811110150m407ea6b3wc265b824a448ee20@mail.gmail.com>
Date: Tue, 11 Nov 2008 09:50:57 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [RFC-PATCH 1/5] unaligned: introduce common header
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1226343084.22742.11.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1225908976.5991.180.camel@brick>
	 <87a5b0800811080447m2cebebb7j77afe9592f72ab11@mail.gmail.com>
	 <1226290940.5478.3.camel@brick>
	 <87a5b0800811100349n435785by27ebc4e495bb7985@mail.gmail.com>
	 <1226335889.5478.40.camel@brick>
	 <87a5b0800811101035i721f1befi79ff76f9169fef4c@mail.gmail.com>
	 <1226343084.22742.11.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 6:51 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Mon, 2008-11-10 at 18:35 +0000, Will Newton wrote:
>> On Mon, Nov 10, 2008 at 4:51 PM, Harvey Harrison
>> <harvey.harrison@gmail.com> wrote:
>> >
>> > In this particular case, packed isn't right as you know big_data is
>> > aligned (as long as you can guarantee the struct alignment), so you'd
>> > probably want:
>> >
>> > struct foo {
>> >        u64 big_data;
>> >        u8 small_data;
>> >        u32 medium_data __attribute__((__packed__));
>> > }
>> >
>> > But that's not what we're talking about in the kernel's case.
>>
>> Perhaps that would be a neater way of expressing what is required in
>> my simple example, but it's fairly common to use packed on the whole
>> struct which could be because a field that is "packed" by default on
>> one architecture might not be on another. You could mark every field
>> as packed but few people seem to do that and as far as I am aware
>> there is no documented difference between packing all members and the
>> whole struct. The gcc documentation for packed is pretty short:
>
> Actually it's documented that putting attribute(packed) on the struct
> is equivalent to putting attribute(packed) on _every_ member of the
> struct.
>
>>   The packed attribute specifies that a variable or structure field
>> should have the smallest
>>   possible alignment—one byte for a variable, and one bit for a field,
>> unless you specify a
>>   larger value with the aligned attribute.
>>
>> I'd love to know if the pointer alignment behaviour is widespread and
>> then maybe write a patch for the gcc manual.
>
> Well, it's kind of the whole point of __packed isn't it?  Otherwise the
> struct members get naturally (or some arch-dependent value) aligned,
> which the compiler can rely on unless you say __packed.
>
> So in my example above, the compiler _knows_ how it has aligned
> big_data and small_data and can use whatever access is most efficient,
> but it can't make any assumptions about medium_data, so access through
> a pointer _must_ be done unaligned.
>
> struct foo *bar;
> bar->medium_data; // compiler must do this unaligned

Agreed, but the packed struct unaligned access code does this:

struct __una_u16 { u16 x __attribute__((packed)); };

On an architecture with struct alignment > 1 this will not work. Which
is why I believe that the memmove code must stay for those
architectures.
