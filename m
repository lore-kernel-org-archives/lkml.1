Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYKJSfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYKJSfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbYKJSfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:35:09 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:63058 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbYKJSfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:35:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tmodDXxzzKJO36yivQV16dALbqjaxr9sJN4Qo7muHX+Vrd6m9o/cljuUetL0SdMOC2
         AoznXDdTXb05g6ymPeCf8NvlXmNlPRSul6tcSXp7HMhabhYun4CQPaN84ul1+tS3uyF+
         wqQktZhoqJrYkuFYCW/JAc+oL+S0I7CIwf5ms=
Message-ID: <87a5b0800811101035i721f1befi79ff76f9169fef4c@mail.gmail.com>
Date: Mon, 10 Nov 2008 18:35:05 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [RFC-PATCH 1/5] unaligned: introduce common header
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1226335889.5478.40.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1225908976.5991.180.camel@brick>
	 <87a5b0800811080447m2cebebb7j77afe9592f72ab11@mail.gmail.com>
	 <1226290940.5478.3.camel@brick>
	 <87a5b0800811100349n435785by27ebc4e495bb7985@mail.gmail.com>
	 <1226335889.5478.40.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 4:51 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Mon, 2008-11-10 at 11:49 +0000, Will Newton wrote:
>> On Mon, Nov 10, 2008 at 4:22 AM, Harvey Harrison
>> <harvey.harrison@gmail.com> wrote:
>>
>> (add back lkml cc that I mistakenly dropped)
>>
>> > On Sat, 2008-11-08 at 12:47 +0000, Will Newton wrote:
>> >> On Wed, Nov 5, 2008 at 6:16 PM, Harvey Harrison
>> >> <harvey.harrison@gmail.com> wrote:
>> >>
>> >> > The memmove-based arches (m32r, xtensa, h8300) are likely going to be fine with this change
>> >> > barring compiler bugs that made them go with memmove in the first place.
>> >>
>> >> As I understand it the need for the memmove implementation is not
>> >> compiler bugs but default struct alignment. The packed struct
>> >> implementation will only work with compilers where structs can be
>> >> aligned on byte boundaries, it's fairly common for RISC architectures
>> >> to align structs to 4 or 8 byte boundaries.
>> >
>> > Which I believe is disabled entirely using __attribute__((packed)), no?
>>
>> As far as I am aware the packed attribute is handled in this way for
>> some toolchains (arm in particular). Not everybody does it, and for
>> good reasons. For example if I have this struct on an architecture
>> with 8 byte default struct alignment:
>>
>
> I should have been more careful with my wording here, I meant that no
> alignment assumptions are made when accessing a packed struct through
> a pointer, as is the case with the kernel version.

I am not aware that this is the case. Do you have any references?

>> struct foo {
>>     u64 big_data;
>>     u8 small_data;
>>     u32 medium_data;
>> } __attribute__((packed));
>>
>> Should big_data be accessed as 8 byte load instructions rather than
>> one 64bit load instruction? It's a pretty large performance penalty to
>> pay when all I really want is for medium_data to be accessed
>> correctly.
>
> In this particular case, packed isn't right as you know big_data is
> aligned (as long as you can guarantee the struct alignment), so you'd
> probably want:
>
> struct foo {
>        u64 big_data;
>        u8 small_data;
>        u32 medium_data __attribute__((__packed__));
> }
>
> But that's not what we're talking about in the kernel's case.

Perhaps that would be a neater way of expressing what is required in
my simple example, but it's fairly common to use packed on the whole
struct which could be because a field that is "packed" by default on
one architecture might not be on another. You could mark every field
as packed but few people seem to do that and as far as I am aware
there is no documented difference between packing all members and the
whole struct. The gcc documentation for packed is pretty short:

  The packed attribute specifies that a variable or structure field
should have the smallest
  possible alignment—one byte for a variable, and one bit for a field,
unless you specify a
  larger value with the aligned attribute.

I'd love to know if the pointer alignment behaviour is widespread and
then maybe write a patch for the gcc manual.
