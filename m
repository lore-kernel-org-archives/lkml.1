Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXKFSCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXKFSCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbXKFSCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:02:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57440 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbXKFSCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:02:05 -0500
Message-ID: <4730AB1F.2030001@zytor.com>
Date: Tue, 06 Nov 2007 09:57:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org>	<m1pryoa1f6.fsf@ebiederm.dsl.xmission.com>	<472F7D8D.8050505@zytor.com> <472F826E.3050008@goop.org>	<472F85F2.6040501@zytor.com> <472FBC83.5060509@goop.org>	<472FBF40.1010300@zytor.com> <472FC0F3.10102@goop.org>	<472FC401.9020202@zytor.com> <47309389.3080403@goop.org>	<47309608.9030200@zytor.com> <47309C85.6030904@goop.org>	<47309D98.8080003@zytor.com> <m1zlxr5mik.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1zlxr5mik.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>
>> I think it should be sparsely used, but stuff like simple end markers is pretty
>> much what it's good for.
>>
>> The main reason I want to avoid adding another header field is that the header
>> is a finite resource; one of the many poor decisions in its original design was
>> using a 2-byte jump at the top, so address 0x281 is the end of the universe.
> 
> That was fixed long ago (by having a 4 byte reserved field in the middle) that
> we can do a two byte jump and then do a farther jump from there to the 16bit
> code.  So as long as we actually use discipline and really reserve
> the field for a further jump there should be no need for 0x281 being the end
> of the universe.
> 

That's not the only complication.  The thing that concern me more is 
boot loaders using the jump as a length indicator, and there is really 
very little chance to test that out safely, except perhaps by breaking 
it immediately (by adding a 16-byte jump at the end; that way we provide 
a minimum of overlap for boot loader authors.)

That being said, I don't see any such field (bootsect_kludge could be 
recycled, arguably, and pad2 is three bytes which is enough for a 16-bit 
jump.)

At the moment, though, that would only push the maximum from 0x281 to 
0x290, then we run into the next field in struct boot_params.  Although 
this field can also be relocated over time, it once again shows that 
breaking this particular limit is nontrivial, and that we're better off 
trying to avoid pushing it.

However, with a little discipline I think we can make 0x281 last us for 
the usable lifetime of this format.  In the 10 years since the 2.00 
format was created, we have only added 36 bytes of header, and we have 
57 bytes left (plus 5 bytes of pad and 6 bytes of recyclable field.) 
When we get closer to full, if we haven't already created a mechanism 
making field additions obsolete I think we would be better off creating 
a pointer to a secondary header than trying to break the limitations 
involved in the current header format.

	-hpa
