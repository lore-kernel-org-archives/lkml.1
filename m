Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYFKKCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYFKKCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYFKKC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:02:26 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:16735 "EHLO
	mail217-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYFKKC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:02:26 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2008 06:02:25 EDT
X-BigFish: VPS-32(z34a4nz1432R98dR7efV1805M3117Kzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2ALMJ-01-KAE-01
Date: Wed, 11 Jun 2008 11:41:30 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>, qt@alberich.amd.com
Subject: Re: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in
	pat_init()
Message-ID: <20080611094130.GA5889@alberich.amd.com>
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484F065B.2050002@keyaccess.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jun 2008 09:41:31.0208 (UTC) FILETIME=[542A1480:01C8CBA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 12:55:23AM +0200, Rene Herman wrote:
> On 10-06-08 16:05, Andreas Herrmann wrote:
>
>> Starting with commit 8d4a4300854f3971502e81dacd930704cb88f606 (x86:
>> cleanup PAT cpu validation) the PAT CPU feature flag is not cleared
>> anymore. Now the error message
>>   "PAT enabled, but CPU feature cleared"
>> in pat_init() is misleading.
>
> No, it's correct. This is to be read as "The PAT feature is enabled in the 
> kernel but the CPU claims to not have PAT". The message is not a leftover 
> from the old flag-clearing setup or anything; it was introduced in the 
> patch that disabled that.

Ok, right you are. It was introduced with the commit that removed the clearing
of the feature flag.

>> Furthermore the current code does not check for existence of the PAT
>> CPU feature flag if a CPU is whitelisted in validate_pat_support.
>
> Which is okay-ish, or at least by design it seems. The paranoia check in 
> pat.c will catch this case.

IMHO this case won't be caught in x86/pat branch.
I guess you haven't checked this feature branch?

To verify the code that I've found there I did the following:

As I had no Transmeta or Centaur CPU at hand I just cleared the PAT
flag in the CPU identification code to simulate the case that all CPUs
of a Vendor are whitelisted (even those w/o PAT support).  The first
time pat_init() is entered you get

  PAT enabled, but CPU feature cleared 
    (=> which is wrong as no flag was cleared)
  x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
    (=> which is wrong as PAT shouldn't be enabled on such CPUs)

For the second CPU BUG_ON will come into play as boot_pat_state is set.
But I guess, that will never be the case on such rather old CPUs.

Furthermore when PAT is really not supported you might get an GP when
writing to the PAT MSR.

The older code was just right to exit pat_init() if the boot cpu had
no PAT feature flag. See pat_known_cpu(void) in the old code
(git show  8d4a4300).

> The current setup is okay really.

No, not in x86/pat branch.
(Or have I missed something, need more coffee or what ... ;-)

IMHO the current state is:

We can whitelist all Transmeta, Centaur and AMD CPUs (no errata wrt
PAT are known).  So the assumption is that for those CPUs PAT works if
advertised.

Then we have Intel for which all family 0xf CPUs, and family 6 CPUs
starting with model 15 are whitelisted. AFAIK there are other Intel
CPUs that advertise PAT support.
See for instance cpuinfo output at http://gentoo-wiki.com/Safe_Cflags
E.g. Pentium M (model 13), Celeron (model 6), Pentium III (model 8).  

Has someone checked for errata regarding PAT for those CPUs? If not,
the whitelist should be kept or at least turned into a blacklist for
the remaining Intel CPUs until this is verified.

> The only thing it still wants is a commandline whitelist switch but
> that needs a somewhat different setup as validate_pat_support() is
> too early for __setup() or early_param().

That should be easy to do. At the latest pat_init() should call
validate_pat_...() (if and only if boot_pat_state==0). Then
introducing some pat=force parameter and the validate function should
ignore the whitelist when this parameter was given and just rely on
the CPU feature flag to activate PAT.


Regards,

Andreas


