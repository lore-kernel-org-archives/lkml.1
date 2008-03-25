Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYCYHZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYCYHZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 03:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYCYHZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 03:25:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:32545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYCYHZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 03:25:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,551,1199692800"; 
   d="scan'208";a="264803705"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nigel@nigel.suspend2.net, Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20080321191226.GA12609@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080311211004.GA30164@redhat.com>
	 <1205286326.29069.16.camel@caritas-dev.intel.com>
	 <m1abl4znw6.fsf@ebiederm.dsl.xmission.com>
	 <20080312193740.GE13549@redhat.com>
	 <1205481808.867.0.camel@caritas-dev.intel.com>
	 <20080321191226.GA12609@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Mar 2008 15:25:10 +0800
Message-Id: <1206429910.29518.32.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 25 Mar 2008 07:22:16.0289 (UTC) FILETIME=[F4061D10:01C88E48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 15:12 -0400, Vivek Goyal wrote:
[...]
> Hi Huang,
> 
> I am kind of ok with both the methods.
> 
> - Communicate information between two kernels using an ELF NOTE
>   prepared by kernel.
> 
> - Communicate information between user space tools using initrd.

I think the ELF_NOTES mechanism is sufficient for communication between
two kernel. Because it can be written from user space tool in the kernel
A (/sbin/kexec via sys_kexec_load), and read from user space tool in the
kernel B (via /proc/vmcore). It can be used as user space communication
mechanism. So I think it may be not necessary to communicate with
initrd.

If we want to load the hibernated image with sys_kexec_load (/sbin/kexec
-l), we must add "multiple stages loading" feature to sys_kexec_load.
Because the segments in the hibernated image can exceed
KEXEC_SEGMENT_MAX (16) easily, considering there will be many memory
holes when free pages are excluded. Multiple sys_kexec_load must be used
to load a normal hibernated image. If multiple stage loading is
unavoidable, I think the better method to communicate information like
"jump back entry" and "backup pages map" is "multiple stage loading"
like you said in previous mail. And they can be encapsulated as
ELF_NOTES. So the only information need to be passed on stack is address
of ELF core header.

> But which method to use will depend on what information we want to 
> exchange between two kernels. 
> 
> For example, re-entry points can be on stack or in ELF NOTE.
> 
> Backup page map probably can be communicated using initrd as only user
> space need to access that (ELF Core headers can be put in a memory area
> which is not swapped during transition from kernel A to B. This way
> kernel B never needs to know that kernel A had done some swapping of
> pages?). 

ELF core headers are in destination memory range of kernel B, so they
can be accessed by kernel B directly without knowing pages swapping in
kernel A.

> So far I have understood only following.
> 
> 1. We need to pass around entry/re-entry points between kernels.
> 
> 2. We need to pass backup pages map from kernel A to kernel B, so that user
>   space tool can do filtering.
> 
> 3. We need to pass address of ELF core headers from kernel A to kernel B so
>   that a valid vmcore of kernel A can be exported.
> 
> 	- For first time boot of kernel B, address of ELF core header is
> 	  passed through command line.
> 
> 	- For re-entry into B, ELF core header address can be passed
>  	  using some register, or on stack or using kernel ELF NOTE.
> 
> What else? What information do we need to communicate from kernel B to 
> kernel A or from kernel C to kernel A?
> 
> I am sure that you have told it in the past. Just that I don't recollect
> it.

For now, there is no information need to be passed from kernel B/C to
kernel A. But I think in the future, there should be some ACPI related
information need to be passed in this way, such as from kernel C to
kernel A: whether system is restored from ACPI S4 or ACPI S5. So I think
it is necessary to make it possible to pass some information from kernel
B/C to kernel A. But I think an ELF core header and some memory is
sufficient to do this.

Best Regards,
Huang Ying

