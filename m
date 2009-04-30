Return-Path: <linux-kernel-owner+w=401wt.eu-S1761801AbZD3L6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801AbZD3L6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 07:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZD3L6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 07:58:17 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:56248
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755332AbZD3L6Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:58:16 -0400
X-BigFish: VPS-27(zz1528M1432R1453M98dR1805M936fJzz1202hzzz32i6bh6di15fn43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KIWX8P-01-8W6-01
Date: Thu, 30 Apr 2009 13:57:41 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
Message-ID: <20090430115741.GA23634@aftab>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <87iqknp8a0.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <87iqknp8a0.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 30 Apr 2009 11:57:46.0145 (UTC) FILETIME=[E03BB910:01C9C98A]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 29, 2009 at 09:30:31PM +0200, Andi Kleen wrote:
> Borislav Petkov <borislav.petkov@amd.com> writes:
> 
> > Hi,
> >
> > thanks to all reviewers of the previous submission, here is the second
> > version of this series.
> 
> The classic problem of the previous versions of these patches was that
> they consume the same error registers (even if using pci config versus
> msrs as access methods) as the kernel machine check poll/threshold
> interrupt code.  And with two logging agents racing on the same
> registers you will always get junk results. Typically with threshold 
> enabled the mce code wins the race. I suspect this patchkit has
> exactly the same fundamental design problem. EDAC really is not
> particularly fitting for integrated memory controllers that report
> their errors using standard machine check events.

ok, how about we remove tha MSR/PCI cfg space reading bits and leave
that task solely to the mce core. Then, iff you have edac turned on in
Kconfig, mce code delivers needed error info to edac which, in turn,
goes and decodes the error/does the mapping to DIMM blocks/supplies DRAM
error injection facility for testing purposes and similar things. That
way you have both and they don't overlap in functionality.

By the way, I think there's a similar attempt/proposal of letting mce
and edac talk to each other from Red Hat so I think this could be a
viable thing to try.

> -Andi (who thinks all of this decoding should be in user space anyways)

Think of a big data center with a thousands of 2,4,8 socket blades
and the admin collecting mce output and running around decoding the
errors on his workstation. Even worse, the blades have different DIMM
configurations due to hw upgrades/newer machines. I'd much rather have
the complete decoding done in kernel, where all the information needed
for proper decoding is present and with the error landing in syslog or
some other monitored buffer instead of reconstructing it in userspace.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

