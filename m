Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYL3XCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYL3XCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYL3XCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:02:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:37850 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751586AbYL3XCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:02:41 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX187MZVsRZw7ZVH3WILNz7EU2dnSenwT/lnR/DjWG1
	5VNhv/j9C7rkit
Message-ID: <495AA891.2030104@gmx.de>
Date: Wed, 31 Dec 2008 00:02:41 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules
 (take 2)
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au>
In-Reply-To: <200812310915.41693.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 30 December 2008 07:04:54 Helge Deller wrote:
>> This is the second take of the patch series.
>> Changes to previous version:
>> - new CONFIG_HAVE_MODULE_SECTION_STUBS config option
>> - put stub entries of a code section in front of the section
>>
>> ____________
>> The parisc port (esp. the 32bit kernel) currently lacks the ability to
>> load large kernel modules like xfs or ipv6. This is a long outstanding
>> bug and has already been reported a few times, e.g.:
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=350482,
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=401439,
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=508489
>>
>> The symptom is like this:
>> # modprobe xfs
>> FATAL: Error inserting xfs
>> (/lib/modules/2.6.26-1-parisc/kernel/fs/xfs/xfs.ko): Invalid module
>> format
>>
>> In dmesg:
>> module xfs relocation of symbol xfs_btree_read_bufs is out of range
>> (0x3ffefffe in 17 bits)
>>
>> The reason for the failure is, that the architecture only provides the
>> R_PARISC_PCREL17F (for 32bit kernels) and R_PARISC_PCREL22F (for PA2.0
>> and 64bit kernels) relocations, which sometimes can't reach the target
>> address of the stub entry if the kernel module is too large. Currently
>> parisc (like other architectures) creates one big PLT section for all
>> stubs at the beginning of the init and core sections.
>>
>> The following two patches changes the parisc module loader to put stubs
>> for the code sections in front of each section, so that the distance to
>> the stubs more easily fits into the available 17/22 bits.
> 
> So now any one section has to pass 17 bits to break?  How close are you with
> the xfs module?

I did not tested it very much, but xfs is around 1.1M on disk, and ~750K when 
loaded. I think it breaked being 1/4 through the relocations.

> But it's kind of nasty, overloading sh_entsize further.  Could we instead
> do something like add a arch_module_section_size() weak fn which you can
> overload?

Sure. I'll respin the patch.

> We'd use that in get_offset() so our layout and size calculations
> were correct, 

Yes, good.

> and use sh_size everywhere else.

BTW, although the comment states that arches can change section sizes 
in the module_frob_arch_sections() function:
/* Allow arches to frob section contents and sizes.  */
it will break horrible if you do so.
What I found was, that if you change sh_size, at least the module
references / dependency chain will break when running lsmod.

Helge
