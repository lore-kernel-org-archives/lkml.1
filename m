Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZKLRe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZKLRe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZKLReY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:34:24 -0500
Received: from mail-va3.bigfish.com ([216.32.180.113]:58850 "EHLO
	mail110-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753633AbZKLReX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:34:23 -0500
X-Greylist: delayed 1503 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 12:34:23 EST
X-SpamScore: -7
X-BigFish: VPS-7(z34a4jz98dN179dNzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-WSS-ID: 0KT0ABB-03-9X4-02
X-M-MSG: 
Date: Thu, 12 Nov 2009 18:09:39 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode
 output messages
Message-ID: <20091112170939.GA31660@aftab>
References: <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
 <20091106194626.GC18592@alberich.amd.com>
 <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
 <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
 <20091111193832.GG18592@alberich.amd.com>
 <20091112113343.GA1386@elte.hu>
 <b647ffbd0911120354s755e2dc0g6f07ef03ae28bd86@mail.gmail.com>
 <b647ffbd0911120406o6e5bd58eq8aa022946f38f5ef@mail.gmail.com>
 <20091112152026.GI18592@alberich.amd.com>
 <b647ffbd0911120748q6e3ddcf9h31b48972aff9e39c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <b647ffbd0911120748q6e3ddcf9h31b48972aff9e39c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 12 Nov 2009 17:09:11.0272 (UTC) FILETIME=[DA66D680:01CA63BA]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 04:48:34PM +0100, Dmitry Adamushko wrote:
> request_firmware_nowait() sends an async request which can be
> preserved (and this is an assumption -- I haven't really verified it
> yet) until some latter stage when user-space has been started and is
> capable of handling (cached) firmware-load requests. I may be (and
> perhaps I'm) wrong with the above assumption and the solution is
> either never build such a module into the kernel or only do it with
> built-in firmware blobs.

I don't think built-in blobs is the way we want to go here - in that
case updating the microcode would require rebuilding the kernel, which
is a clear overkill and exactly the opposite of what we should be doing.
Imagine a big supercomputer consisting of several thousand nodes, all
with identical CPUs. Now, everytime there's microcode patch available,
you have to reboot all those machines after having distributed the
updated kernel images just so that all nodes have their microcode
updated. Many admins would go: "Hmm, no!"

What actually got somehow dropped from Andreas' patch and which we
talked about and agreed upon earlier is that the best thing to do would
be to do

$ rmmod microcode
$ modprobe microcode

after having copied the new ucode patch to /lib/firmware without
disturbing the machine execution.

The async _nowait() version sounds good but in that case you're still
going to need to trigger the microcode update somehow (and AFAIK there's
no mechanism for that yet.) So reloading the module is the easiest thing
and it doesn't need any code changes except the Kconfig oneliner.

Hmm...

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

