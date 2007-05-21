Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbXEUMHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbXEUMHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbXEUMHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:07:12 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:27338 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbXEUMHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:07:10 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30515599:sNHT26327315"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Date: Mon, 21 May 2007 13:07:05 +0100
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC0B174C8F@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Thread-Index: AcebnMDpTKskD8bvQlS4RBYJBnUtjgAARBsA
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>, "Bryan Wu" <bryan.wu@analog.com>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 21 May 2007 12:07:08.0763 (UTC) FILETIME=[8E49EAB0:01C79BA0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was fixing this issue some time ago.

With CONFIG_VT (drivers/char/vt.c) enabled and a USB HID keyboard connected, we were seeing bad pointer dereferences in drivers/char/keyboard.c

In function kbd_keycode vc_cons[fg_console].d was un-initialized .

static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
{
--snip--
	struct vc_data *vc = vc_cons[fg_console].d;

--snip--
	tty = vc->vc_tty;
--snip--
}	

The workaround, almost any arch does is to initialize conswitchp with the dummy console.

conswitchp = &dummy_con;	

The dummy console gets automatically selected if there is no other suitable console (VGA).
The bit we were missing is simply this fix.

Best regards,
Michael


------------------------------------------------------------------
********* Analog Devices GmbH         michael.hennerich@analog.com
**  *****                                      Systems Engineering
**     ** Wilhelm-Wagenfeld-Strasse 6       
**  ***** D-80807 Munich                      
********* Germany                          
Registergericht München HRB 40368,  Geschäftsführer:  Thomas Wessel, William A. Martin, Margaret Seif

>-----Original Message-----
>From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of Pekka
>Enberg
>Sent: Montag, 21. Mai 2007 13:40
>To: Bryan Wu
>Cc: torvalds@linux-foundation.org; akpm@linux-foundation.org; linux-
>kernel@vger.kernel.org; Michael Hennerich
>Subject: Re: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard
>crashes kernel
>
>Hi Bryan,
>
>On 5/21/07, Bryan Wu <bryan.wu@analog.com> wrote:
>> +#ifdef CONFIG_DUMMY_CONSOLE
>> +       conswitchp = &dummy_con;
>> +#endif
>>         cclk = get_cclk();
>>         sclk = get_sclk();
>
>This patch has no changelog. While it is probably apparent to you why
>this fixes a crash when using an USB keyboard, it would be nice for
>the rest of us to know which crash it fixes and why.
