Return-Path: <linux-kernel-owner+w=401wt.eu-S933720AbYA2SUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbYA2SUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYA2STM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:19:12 -0500
Received: from smtp03.mtu.ru ([62.5.255.50]:49664 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYA2STK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:19:10 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Udev coldplugging loads 8139too driver instead of 8139cp
To: Ondrej Zary <linux@rainbow-software.org>, linux-kernel@vger.kernel.org
Date: Tue, 29 Jan 2008 21:18:59 +0300
References: <1201554992.13883.13.camel@Anastacia> <20080128170830.6f67fa5a@deepthought> <479F0369.3080309@msgid.tls.msk.ru> <200801291753.18578.linux@rainbow-software.org>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20080129181903.A8AE618712F0@smtp03.mtu.ru>
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:

> On Tuesday 29 January 2008 11:43:53 Michael Tokarev wrote:
>> Stephen Hemminger wrote:
>> > On Tue, 29 Jan 2008 03:46:08 +0300
>> > Michael Tokarev <mjt@tls.msk.ru> wrote:
>>
>> []
>>
>> >> There are 2 drivers for 8139-based NICs.  For really different two
>> >> kinds
>> >> of hardware, which both uses the same PCI identifiers.  Both drivers
>> >> "claims" to work with all NICs with those PCI ids, because
>> >> "externally" (by means of udev for example) it's impossible to
>> >> distinguish the two kinds of hardware, it becomes clean only when the
>> >> driver (either of the two) loads and actually checks which hardware we
>> >> have here.
>> >
>> > Is there any chance of using subdevice or subversion to tell them
>> > apart? That worked for other vendors like DLINK who slapped same ID on
>> > different cards.
>>
>> If it were that simple... ;)
>>
>> No.  The difference is in PCI revision number (byte #8 in PCI config
>> space). If it's >= 0x40 - it's 8139too, < 0x40 - 8139cp.  Or 0x20 - I
>> forgot.
> 
> Perhaps a module could be created that will claim this device ID and then
> use the correct driver.
> 

C'mon, really ...

echo 'alias ...v000010ECd00008139... 8139too' >> /etc/modprobe.conf


>> Here's a code snippet from a shell script I used ages ago to
>> automatically load modules (similar to what udev does nowadays):
>>
>>   # special hack for 8139{too,cp} stuff
>>   case "$modalias" in
>>   *v000010ECd00008139*)
>>     rev="$(dd if="$1/config" bs=1 skip=8 count=1 2>/dev/null)"
>>     if [ -n "$rev" ]; then
>>       list=
>>       for module in $modlist; do
>>         case "$module" in
>>         8139cp)
>>           if [ ".$rev" \< ". " ]; then
>>             $vecho1 "$TAG: not loading $module for this device"
>>             continue
>>           fi
>>           ;;
>>         8139too)
>>           if [ ".$rev" \> ". " ]; then
>>             $vecho1 "$TAG: not loading $module for this device"
>>             continue
>>           fi
>>           ;;
>>         esac
>>         list="$list $module"
>>       done
>>       modlist="$list"
>>     fi
>>     ;;
>>   esac
>>
>> /mjt
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


