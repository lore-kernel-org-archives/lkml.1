Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYDLTJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYDLTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbYDLTJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:09:50 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:57736 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbYDLTJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:09:49 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Date: Sat, 12 Apr 2008 20:09:29 +0100
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <20080412180219.GI3402@khazad-dum.debian.net> <200804122014.41583.IvDoorn@gmail.com>
In-Reply-To: <200804122014.41583.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804122009.29968.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sat, 12 Apr 2008 19:09:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008 19:14:41 Ivo van Doorn wrote:
> > Separate hot keys/buttons?  I haven't seen it, but check commit
> > 90da11514562020ea7d697982f912ac949adc317's comment.  That was the commit
> > which added KEY_WLAN and KEY_BLUETOOTH, back in 2.6.18-rc.  Maybe ask
> > Lennart Poettering about it?
>
> My laptop (Acer Ferrari 3200) features 2 keys, 1 for 802.11 and 1 for
> Bluetooth. Both directly communicate to the hardware itself and only need
> rfkill for notification purposes to userspace.

The Ferrari's are the odd-one-out of Acer's lineup - these generally tend to 
just work out-of-the-box for the wireless and bluetooth buttons.

Most of the other Acer laptops just have software buttons (KEY_WLAN and 
KEY_BLUETOOTH), and need another driver to make them do anything (acer-wmi is 
one example), and the wireless card has no control over it's rfkill switch 
(though there are a few cases where this is apparently not the case).

Although the current wireless driver implementations of rfkill/ input polling 
have been causing me a bit of a headache lately, with no nice solution in 
site, because of the following (b43 does this, but I suspect rt2x00 may also 
do the same, so it's a slightly more generic problem). Now, I have a patch 
locally to add rfkill support to acer-wmi, but still keep seeing the 
following:

1) acer-wmi loads
2) Press KEY_WLAN
3) rfkill-input notifies all registered KEY_WLAN rfkill drivers that KEY_WLAN 
has been pressed.
4) acer-wmi toggles the wireless radio state
5) b43 notices this state change because of it's polling, then sends a 
KEY_WLAN event (even though b43 knows it can't control the radio on my 
laptop)
6) Goto 3.

And this continues in a loop. Removing the offending input_report_key() lines 
in the wireless driver stops this.

Ideally, I think we are going to need some way of saying that platform 
firmware level drivers (e.g. acer-wmi, thinkpad-acpi, etc) take priority over 
the wireless drivers, and that the drivers should _not_ send out these 
KEY_WLAN events if one of acer-wmi, etc are loaded (or find some other nice 
way of handling this).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
