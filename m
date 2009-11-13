Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbZKMQXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbZKMQXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZKMQW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:22:56 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38212 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbZKMQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:22:56 -0500
Date: Fri, 13 Nov 2009 16:23:01 +0000
To: Pavel Machek <pavel@ucw.cz>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Matteo Croce <technoboy85@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <20091112121805.GF1394@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112121805.GF1394@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 01:18:05PM +0100, Pavel Machek wrote:
> Interesting...geode gx being buggy? I know pentium was famous for the
> fdiv bug, but never heard of geode gx problems...
> 
> Are they something kernel can work around, or do those chips just have
> to be avoided? Anything malicious user can use to crash the system?
> Anything malicious user can use to gain extra priviledge?

Well the one problem I have encountered is in the jsm driver (exar pci
uart driver).

On a typical PC with a P3, P4, Core 2, athlong, etc, it works perfectly.
It works perfectly on a Geode LX as well.  On a Geode SC1200 (which
is a GX with companion chip in one) it transmits out of order in a
consistent way.

If you transmit a chunk of data that looks like this:

0123456789abcdef

The data that comes out of the UART is:

123056749ab8defc

The fix to avoid the problem is:

-               memcpy_toio(&ch->ch_neo_uart->txrxburst, ch->ch_wqueue + tail, s);
+               for(i=0;i<s;i++) {
+                       memcpy_toio(&(ch->ch_neo_uart->txrxburst[i]), ch->ch_wqueue + tail + i, 1);
+               }

Calling memcpy_toio on the Geode SC1200 on anything larger than 1 byte
causes the data to be delivered (at least on the PCI bus) reordered in
that very consistent manner.

The alignment doesn't affect it (I tested that).  Simply doing more than
1 byte at a time with memcpy_toio to the pci device messes up.

So as a result we run with this patch applied even though it certainly
is less efficient, but at least it works.

Every other CPU works fine that I have ever tried the driver on.

-- 
Len Sorensen
