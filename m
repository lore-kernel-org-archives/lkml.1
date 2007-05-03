Return-Path: <linux-kernel-owner+w=401wt.eu-S376193AbXECQX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376193AbXECQX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376197AbXECQX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:23:56 -0400
Received: from gw.goop.org ([64.81.55.164]:55921 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376193AbXECQXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:23:54 -0400
Message-ID: <463A0C9E.4010402@goop.org>
Date: Thu, 03 May 2007 09:23:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>	<46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org>	<4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org>	<4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org>	<463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com>	<m1tzuuv24z.fsf@ebiederm.dsl.xmission.com> <463989BD.6040603@goop.org> <m1ps5iujl8.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ps5iujl8.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Yes.  I guess in this context, I am generally for building the ELF
> headers by hand instead of with a linker script, because then we
> know exactly what is happening and can ensure everything is just so.
>   

Yes, it seems easiest - particularly given how flaky binutils can get
when you really try to control its ELF generation.

> Sorry, for not being clear I have been expecting to do this for years,
> it is one of the reasons I keep coming back to putting an ELF header
> on the bzImage. 
>   

OK.  It seems obvious, but I just wanted to make sure ;)

>> In the Xen case, its obviously the domain builder who creates the
>> mappings, and we can easily implement p != v mappings.  But when booting
>> native, presumably paging is off at this stage, and only identity maps
>> can be implemented.  I guess the rough rule is that if paging is enabled
>> on entry, the kernel should expect all the bzImage mappings to be in
>> place, but if paging is off, well, the question is moot.
>>     
>
> Right.  Except that there is a bit of a catch 22 in the
> para-virtualized environments of setting up the page tables, I'm not
> at all certain what the gain of setting up p != v mappings are.
>   

Well, that's more or less it.  If the decompressor ends up jumping to
startup_32, and that immediately goes into xen_start_kernel(), then
we're still running on the initial bzImage p=v pagetables.  At the
moment, when the domain builder maps the kernel's vmlinux to the vaddrs
in its Phdrs, so there's no need to do any more boot-time pagetable
manipulation.  If we come out of bzImage with only identity mappings,
then obviously the Xen case will need to do the same pagetable setup as
the native case - which is good so long as we can work out how to share
the code to do so.

For i386, it looks like this will be tricky because at this point:

    * we're not running at the linked address, so C code will be tricky
      and non-standard
    * we need to deal with multiple hypervisors and their constraints on
      what can be in a pagetable
    * we could be running with no paging, or paging in either non-PAE or
      PAE modes

Writing some code which can deal with all of those at once will be an
interesting exercise.

> Part of what I find compelling about this is our initial page tables
> for linux have always had more going on than the virtual addresses
> just being at a constant offset from of the physical addresses, so
> the actions of the current domain builders have me concerned that they
> may be violating some early linux booting assumptions and are
> currently just getting lucky.  Moving the page table setup code into
> the kernel removes that dependency from the domain builders.

The nice thing about having the domain builder create the pagetables is
that it turns it from a tricky bootstrap problem into a relatively easy
job.  The main thing is that the domain builder can create a scaffolding
pagetable which is enough to get everything started.  Once you have that
in place, its pretty easy to update it to set precisely the right bits
in the ptes, etc.

It also means that the path for Xen vs native will be more similar,
because the bzImage code won't need to deal with pagetable setup at all:
for native it won't matter, and for Xen it has already been done.  It
only matters once we hit the 32-bit kernel-proper code, and we diverge
at that point anyway.

    J
