Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZKQXZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZKQXZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZKQXY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:24:58 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:49963 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZKQXY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LnhJj6pp8lw0VKsmmA00Ypj+YV7o8jamhLVWWI24jxv1ofZY6Ha8ELg9RTNBkXUk1a
         0g0XaiPk45Y5vZ55ME/IHFImTxEldcKZmpBhzkcwAFxDvbpyFYRyzBwiL5OB/leeJwsl
         kCrPPnIHSdcOH0+vtxcSZxJ3n27zk4PY5tv0Q=
MIME-Version: 1.0
In-Reply-To: <20091117141314.0238a49b.akpm@linux-foundation.org>
References: <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com> 
	<7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com> 
	<1255516134-4838-1-git-send-email-graff.yang@gmail.com> <18475.1255529305@redhat.com> 
	<6207.1255706090@redhat.com> <23382.1255707790@redhat.com> 
	<1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com> <20091117141314.0238a49b.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 17 Nov 2009 18:24:43 -0500
Message-ID: <8bd0f97a0911171524r35783fa3o393c9584cc8f6634@mail.gmail.com>
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       graff.yang@gmail.com, linux-kernel@vger.kernel.org,
       gyang@blackfin.uclinux.org, uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 17:13, Andrew Morton wrote:
> On Fri, 16 Oct 2009 11:55:29 -0400 Eric Paris wrote:
>> On Fri, 2009-10-16 at 16:43 +0100, David Howells wrote:
>> > Eric Paris <eparis@redhat.com> wrote:
>> > > That would still call cap_file_mmap() and wouldn't solve your problem.
>> >
>> > Hmmm...  I guess I don't see the problem occur because I always run the
>> > programs as root.
>>
>> most likely yes, your processes are going to have CAP_SYS_RAWIO and will
>> happily sail through the cap_file_mmap().
>>
>> > I would guess that cap_file_mmap() and selinux_file_mmap() are, perhaps, too
>> > strict.  The hint shouldn't be rejected unless MAP_FIXED is also set, surely,
>> > but should rather be revised upwards.
>>
>> On the mmu side we don't check until the kernel has turned the hint into
>> a real address.  Which is apparently different then where the hook was
>> originally placed in the nommu side.
>>
>> > Certainly, addr==NULL and !MAP_FIXED is a reasonable case to permit, even in
>> > tightly secured MMU and SELinux mode...  After all, the manual page says:
>> >
>> >     If addr is NULL, then the kernel chooses the address at which to create
>> >     the mapping; this is the most portable method of creating  a  new  map-
>> >     ping.
>>
>> I agree, I think the choices are
>>
>> A) agree that we just shouldn't check the address on nommu
>>    A1) change kconfig to not allow the setting of these
>>       (easy to do for the LSM check, but not easy as it stands today
>>        for the cap_file_mmap() check)
>>    A2) change the addr_only to be a flags which indicate not to check
>>       (my original suggestion)
>>    A3) push the config_nommu down into the security code
>>       (your patch)
>> B) actually check the address, which requires moving the hook to a
>> location where it has been resolved.
>>       (graff yang's patch)
>>
>> I'll leave it up to you to determine which you like the best since you
>> know the implications of nommu.
>
> So what's the status of this issue now?  Should I merge the below into
> 2.6.32?

i think the patch as posted is the way to go, at least for now, and
should be merged.  it certainly works for us under Blackfin going by
Graff's tests.  but obviously this is ultimately David's call.
-mike
