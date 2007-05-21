Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbXEUNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbXEUNtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbXEUNtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:49:09 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:43631 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbXEUNtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:49:08 -0400
X-IronPort-AV: i="4.14,561,1170651600"; 
   d="scan'208"; a="39536503:sNHT25281669"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Date: Mon, 21 May 2007 14:49:03 +0100
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC0B175252@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Thread-Index: AcebpqBwaiv0UeiQTt6GHCzsO41ERAABTx4Q
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: "Bryan Wu" <bryan.wu@analog.com>, <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 May 2007 13:49:06.0451 (UTC) FILETIME=[CCB70630:01C79BAE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm also not an expert...
  
But without conswitchp preset (potential fix):

During initcalls: con_init is called, and returns because of
!display_desc.

static int __init con_init(void)
{
	const char *display_desc = NULL;
	struct vc_data *vc;
	unsigned int currcons = 0, i;

	acquire_console_sem();

	if (conswitchp)
		display_desc = conswitchp->con_startup();
	if (!display_desc) {
		fg_console = 0;
		release_console_sem();
		return 0; // RETURNS HERE
	}

--snip--

}

At this point there is no memory allocated for vc_cons[].d
A bit later vty_init calls kbd_init.

int __init vty_init(void)
{

--snip--
	kbd_init();
--snip--

}

>From now on events are passed to kbd_event which will then call
kbd_keycode.
I don't see where vc_cons[].d in between there is initialized.
 

>-----Original Message-----
>From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of Pekka
>Enberg
>Sent: Montag, 21. Mai 2007 14:51
>To: Hennerich, Michael
>Cc: Bryan Wu; torvalds@linux-foundation.org; akpm@linux-foundation.org;
>linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard
>crashes kernel
>
>On 5/21/07, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
>> With CONFIG_VT (drivers/char/vt.c) enabled and a USB HID keyboard
>connected,
>> we were seeing bad pointer dereferences in drivers/char/keyboard.c
>>
>> In function kbd_keycode vc_cons[fg_console].d was un-initialized.
>
>On 5/21/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> Makes sense. Please consider adding this to the changelog. Thanks.
>
>I am not an expert on this, but I don't see how vc_cons[fg_console].d
>would be uninitialized. It is always set in
>drivers/char/vt.c:con_init() and drivers/char/vt.c:vc_allocate(). The
>conswitchp change affects vc->vc_sw but I don't see that being used in
>drivers/char/keyboard.c:kbd_keycode() except indirectly via
>set_console et al.
>
>Perhaps I am missing something here?
