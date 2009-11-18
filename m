Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZKRRBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZKRRBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZKRRBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:01:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49998 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbZKRRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:01:37 -0500
To: David VomLehn <dvomlehn@cisco.com>
Cc: dedekind1@gmail.com, Marco Stornelli <marco.stornelli@gmail.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
References: <1258463404.27437.103.camel@localhost>
	<m1pr7hf93s.fsf@fess.ebiederm.org>
	<20091117235627.GA13469@dvomlehn-lnx2.corp.sa.net>
	<m1iqd8ptg9.fsf@fess.ebiederm.org>
	<20091118005337.GA19374@dvomlehn-lnx2.corp.sa.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Nov 2009 09:01:36 -0800
In-Reply-To: <20091118005337.GA19374@dvomlehn-lnx2.corp.sa.net> (David VomLehn's message of "Tue\, 17 Nov 2009 19\:53\:37 -0500")
Message-ID: <m1bpizahsf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn <dvomlehn@cisco.com> writes:

>> > 2. Where would you suggest tying in? (Particularly since not all architectures
>> >    currently support kdump)
>> 
>> No changes are needed kernel side.  You just need an appropriate kernel and
>> initrd for your purpose.
>
> I think I must still be missing something. I have dynamic data that I want
> to preserve as I reboot from a failed kernel to a fresh new kernel. By
> the time the fresh kernel starts init, the dynamic data (IP addresses, MAC
> addresses) has been re-written with new values. This is why I'm trying to
> preserve, but I may be running without disk or flash. This patch doesn't
> preserve the data, but it gets it into the kernel so that it can be
> preserved. At present, I'm preserving the data in a panic_notifier function,
> but I am not wedded to that. At present, the data will be copied to a
> section of memory retained across boots, but I know others will want to
> write to flash.

For memory retained across reboots, my inclination is to have a trivial
little tty/console driver that writes into that retained memory.  You can
open the tty and write your user space data, and then at kernel panic time
the kernel will write it's data.

When people start writing to flash anything short of the most trivial
writes is non-trivial code that requires sleeps etc, etc.  Not
something that is particularly reliable after a kernel failure.  My
inclination in that case is to use crash_kexec and a small crash
kernel/initrd or if size is a real issue a standalone binary (ideally
Aboot like so different embedded platforms can share).

I'm sensitive about getting anything extra in the path before we call
crash_kexec as that is likely to lead to destabilization of that path.

Eric
