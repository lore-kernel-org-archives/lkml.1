Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0BAWAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:00:53 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33898 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0BAWAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:00:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pDGJU9zg8xDtsrclMxQWYj6EhnSLD0vbh3DjtxSYD8FcOhZyRLQDSVnb/YCmk/7GDm
         WgBKdXlbFjuPpY4ZQhIlAvVMAQNPnxkz4UJXRKNlWMknyZ7NadmgfDx28nX82yDpnH1X
         wD4QxHriJFa2tXdH161LtGH8gvC5jp2J2bjfY=
MIME-Version: 1.0
In-Reply-To: <1265051657.31341.56.camel@localhost.localdomain>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	 <de962C6zBxL.A.lME.FFiZLB@chimera>
	 <1264986406.31341.5.camel@localhost.localdomain>
	 <4B6711E2.6010409@xenontk.org>
	 <1265051657.31341.56.camel@localhost.localdomain>
Date: Mon, 1 Feb 2010 14:00:46 -0800
Message-ID: <2d5a2c101002011400o53a69f5ap3757ecba41199499@mail.gmail.com>
Subject: Re: [Bug #15127] Bluetooth: sleeping function called from invalid 
	context
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: davidjon@xenontk.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 1, 2010 at 11:14 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi David,
>
>> >> This message has been generated automatically as a part of a report
>> >> of regressions introduced between 2.6.31 and 2.6.32.
>> >>
>> >> The following bug entry is on the current list of known regressions
>> >> introduced between 2.6.31 and 2.6.32. аPlease verify if it still should
>> >> be listed and let me know (either way).
>> >>
>> >>
>> >> Bug-Entry а: http://bugzilla.kernel.org/show_bug.cgi?id=15127
>> >> Subject а а а а а а: Bluetooth: sleeping function called from invalid context
>> >> Submitter а: David John <davidjon@xenontk.org>
>> >> Date а а а а а а а : 2010-01-12 9:19 (20 days old)
>> >> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e726b17422bade75fba94e625cd35fd1353e682
>> >> References : http://marc.info/?l=linux-kernel&m=126328727021949&w=4
>> >
>> > you have an outdated email from Luiz and I change it to the right one
>> > now.
>> >
>> > I looked with him at the patch and I think this will fix it:
>> >
>> > diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
>> > index fc5ee32..2b50637 100644
>> > --- a/net/bluetooth/rfcomm/core.c
>> > +++ b/net/bluetooth/rfcomm/core.c
>> > @@ -252,7 +252,6 @@ static void rfcomm_session_timeout(unsigned long
>> > arg)
>> > а а BT_DBG("session %p state %ld", s, s->state);
>> >
>> > а а set_bit(RFCOMM_TIMED_OUT, &s->flags);
>> > - а rfcomm_session_put(s);
>> > а а rfcomm_schedule(RFCOMM_SCHED_TIMEO);
>> > а}
>> >
>> > @@ -1920,6 +1919,7 @@ static inline void rfcomm_process_sessions(void)
>> > а а а а а а if (test_and_clear_bit(RFCOMM_TIMED_OUT, &s->flags)) {
>> > а а а а а а а а а а s->state = BT_DISCONN;
>> > а а а а а а а а а а rfcomm_send_disc(s, 0);
>> > + а а а а а а а а а rfcomm_session_put(s);
>> > а а а а а а а а а а continue;
>> > а а а а а а }
>> >
>> > We need some extra testing on this with the actual hardware we did the
>> > patch for. So this will take at least a few days before we get our hands
>> > on it.
>>
>> FWIW, your patch fixes the issue.
>
> nice. So I can add a tested-by line to the final patch?
>
> Just our of curiosity, which hardware did you test this with. We only
> know about one headset that should cause this issue.
>

Just in case, here is the hcidump of the Nokia HS-12W, the one that
has problem when we connection authorization is denied:

> ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0041 len 4 [psm 3]
      RFCOMM(s): SABM: cr 1 dlci 26 pf 1 ilen 0 fcs 0xe7
< ACL data: handle 11 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0042 scid 0x0040
< ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0044 len 4 [psm 3]
      RFCOMM(s): DM: cr 1 dlci 26 pf 1 ilen 0 fcs 0xcd
> HCI Event: Number of Completed Packets (0x13) plen 5
> ACL data: handle 11 flags 0x02 dlen 12
    L2CAP(s): Disconn rsp: dcid 0x0042 scid 0x0040
< ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0044 len 4 [psm 3]
      RFCOMM(s): DISC: cr 0 dlci 0 pf 1 ilen 0 fcs 0x9c
> ACL data: handle 11 flags 0x02 dlen 8
    L2CAP(d): cid 0x0041 len 4 [psm 3]
      RFCOMM(s): UA: cr 0 dlci 0 pf 1 ilen 0 fcs 0xb6
< ACL data: handle 11 flags 0x02 dlen 12
    L2CAP(s): Disconn req: dcid 0x0044 scid 0x0041
> HCI Event: Number of Completed Packets (0x13) plen 5
> ACL data: handle 11 flags 0x02 dlen 12
    L2CAP(s): Disconn rsp: dcid 0x0044 scid 0x0041
< HCI Command: Disconnect (0x01|0x0006) plen 3
> HCI Event: Command Status (0x0f) plen 4
> HCI Event: Disconn Complete (0x05) plen 4

So this means the patch works. DISC 0 is send from our side (due to
the session timeout) when normally it should be other end that
disconnects right away when we respond with DM.

-- 
Luiz Augusto von Dentz
Engenheiro de Computaчуo
