Return-Path: <linux-kernel-owner+w=401wt.eu-S933505AbZLPGye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbZLPGye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933427AbZLPGyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:54:31 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:39525 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106AbZLPGy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:54:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ox9gjweDNkPbKYl2hppzoi8W9okf6DGEVWIJKjSsv/WsfNspPbVvozKL8T3i/KDmQA
         ifdHi9ih5CDQnPK9i3IvFes3L92kha5jZKCSHmkuLyv5f9BgHqwRmE6BI35zpJUikid+
         wagiqQ6iqo5ifMauzsry2RHJuGvmWr/1Ro3F0=
MIME-Version: 1.0
In-Reply-To: <1260873307.3692.10.camel@johannes.local>
References: <1260650850-16163-1-git-send-email-daniel@caiaq.de>
	 <1260871411.3692.4.camel@johannes.local>
	 <1260871634.3692.6.camel@johannes.local>
	 <200912151130.59103.holgerschurig@gmail.com>
	 <1260873307.3692.10.camel@johannes.local>
Date: Wed, 16 Dec 2009 01:54:26 -0500
Message-ID: <787b0d920912152254r4bd3e1e2l14fbe7c1fdf42e60@mail.gmail.com>
Subject: Re: [PATCH] wireless: wext: allocate space for NULL-termination for 
	32byte SSIDs
From: Albert Cahalan <acahalan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <holgerschurig@gmail.com>, m.hirsch@raumfeld.com,
       libertas-dev@lists.infradead.org, dcbw@redhat.com,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org, daniel@caiaq.de,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 5:35 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-12-15 at 11:30 +0100, Holger Schurig wrote:
>> > drivers/net/wireless/libertas$ grep lbs_deb_ * | grep ssid
>> > |grep '%s'
>> > assoc.c:    lbs_deb_join("current SSID '%s', ssid length %u\n",
>> > assoc.c:    lbs_deb_join("requested ssid '%s', ssid length %u\n",
>> > assoc.c:    lbs_deb_join("ADHOC_START: SSID '%s', ssid
>> >               length %u\n",
>> > scan.c:             lbs_deb_wext("set_scan, essid '%s'\n",
>>
>> All those lines are gone once my cfg80211 lands.
>>
>> Do you know any way to make sparse moan about them?
>
> Sorry, no, I don't think that's even possible unless you play dirty with
> tricks like __iomem uses for instance but that'd require a lot of
> casting in otherwise valid uses.
>
>> BTW: the libertas firmware sometimes treat an SSID as a
>> zero-terminated string. There are some firmware commands that
>> accept just an u8[32] bytes for the SSID, but not an ssid_len,
>> e.g. in the CMD_802_11_AD_HOC_START command.
>>
>> You therefore can't connect to the otherwise legitimate SSID of
>> TEST\0\0\0.
>
> Ick! I guess your cfg80211 IBSS join handler needs to check for that
> then and refuse such an SSID.

No, pad the SSID out to 32 bytes and let the firmware try.

First of all, isn't TEST\0\0\0 simply the wrong length anyway?
(that is, a length other than 32 is nonsense AFAIK)

Second of all, even if that is valid, the firmware probably handles
at least one SSID that starts with TEST and has some number
of NUL bytes on the end. Since you can't tell what that would be
with a particular firmware version, you might as well just let the
firmware try. The worst case failure here is that there is more than
one SSID of this form and you connect to the wrong one. If you
have a problem with this kind of trouble then you need ethernet.
