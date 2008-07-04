Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYGDPKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYGDPKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYGDPKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:10:30 -0400
Received: from n62.bullet.mail.sp1.yahoo.com ([98.136.44.35]:41879 "HELO
	n62.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752964AbYGDPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:10:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 33888.29690.bm@omp301.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=CJfC+laikxRd2pVq53PEmUsdbmfQUYyqAxF0IocahxC14vknvBRvmTF3oQXTt36Jrc2EIIoBvNbnkPabnN3kxpIIIoSuhxptcL6JA1CAoLj+Q9VhzNFDnHisY53z6Q9W5GJBTzVwC2OCfS+42OC0oUr3argYU1QgeuFymdtZEkA=;
X-Mailer: YahooMailWebService/0.7.199
Date: Fri, 4 Jul 2008 08:10:27 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: mac80211 No ProbeResp drives me bonkers
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <828653.94358.qm@web46113.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moin moin!

The newer mac80211 code has caused me grief in my attempts to use
post-2.6.24 kernels, accessing a somewhat remote AP, for which the
old softmac code (plus at least one hack) worked ``reliably'' or
``well'', or ``kinda worked'' and ``maybe''.

The most annoying problem is that the following section of code is
triggered far too often -- anywhere from hourly intervals to less
than a minute, depending on something -- what, I don't know.

Code, with hack that has let me remain online overnight, even during
a bit of what must suffice for ``sleep'':
as last seen in net/mac80211/mlme.c ...


    992                 if (time_after(jiffies,
    993                                sta->last_rx + IEEE80211_MONITORING_INTER    993 VAL)) {
    994                         if (ifsta->flags & IEEE80211_STA_PROBEREQ_POLL)
    994 {
    995                                 printk(KERN_DEBUG "%s: No ProbeResp from    995  "
    996                                        "current AP %s - assume out of "
    997                                        "range\n",
    998                                        dev->name, print_mac(mac, ifsta->    998 bssid));
    999 #if 0 /* XXX  AAAGH this seems to kick me off too much, KILL  */
   1000                                 disassoc = 1;
   1001                                 sta_info_unlink(&sta);
   1002                         } else
   1003 #endif /* XXX  cause of high blood pressure */
   1004 } /* XXX HACK */
   1005                                 ieee80211_send_probe_req(dev, ifsta->bss   1005 id,
   1006                                                          local->scan_ssi   1006 d,


This from a recent (week-old-ish) 2.6.26-rc8 kernel.

I've added no further debuggery to see exactly what's going on.
A hypothesis I have is that this sometimes-weak (but not since I
added the above XXX-pr0n hack, all hail Murphy, too bad I didn't
*need* uninterrupted 'net access during this time) AP sends some
data that gets lost due to one or more of the following:

*  rapid fluctuations in signal strength, related to the fact that
   at times the Beacons sent are sometimes not receivable for hours

*  the fact this is not an isolated network, with many APs sending
   Beacons on this channel, as well as even more operating on nearby
   channels (overlap), so collisions are inevitable.  Since I was
   repeatedly kicked off at intervals of a minute or so when I was
   trying to take care of ``important'' ``work'' one afternoon, I
   suspect that was due to corrupted packets.  Maybe other ``people''
   were online and interfering with me packets.  I could reassociate
   immediately at signal levels which qualify as ``never seen better''
   from that AP, so it wasn't signal fade.

*  something else blindingly obvious that I'm not seeing.


I'm guessing there's no retries in the code (haven't worked up the
courage and awakeness to actually check) or that the retries are in
too-short a time interval to make a difference -- which is another
Issue I have with mac80211 compared with softmac with this particular
AP (more later about that, maybe)


With the above hack, I've been online for longer than would be
possible without, as I've logged the times I would have been kicked
off.  My fear, apparently unfounded, was that I'd be syslog-bombed
by these messages, but so far they appear occasionally, yet enough
to be annoying because they forcibly threw me off.  Still waiting to
see how it handles signal dropping below the point of communication.


[193012.201642] wlan1: RX deauthentication from 00:...
                [normal reassociation...]
[193013.206729] wlan1: associated
[208709.210335] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[210407.210307] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[214612.381539] wlan1: RX deauthentication from 00:...
[214613.386331] wlan1: associated
[215812.391525] wlan1: RX deauthentication from 00:...
[215813.398349] wlan1: associated
[217012.401289] wlan1: RX deauthentication from 00:...
[217013.409378] wlan1: associated
[218212.412629] wlan1: RX deauthentication from 00:...
[218213.419281] wlan1: associated
[219089.410133] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219141.410157] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219153.410152] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219229.410140] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219412.421206] wlan1: RX deauthentication from 00:...
[219413.427770] wlan1: associated
[219427.420189] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219445.420157] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219531.420166] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219621.420130] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219631.420146] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[219991.420157] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[221212.437209] wlan1: RX deauthentication from 00:...
[221213.435806] wlan1: associated
[222412.448670] wlan1: RX deauthentication from 00:...
[222413.447710] wlan1: associated
[223612.458562] wlan1: RX deauthentication from 00:...
[223613.457670] wlan1: associated
[224812.468496] wlan1: RX deauthentication from 00:...
[224813.471239] wlan1: associated
[226012.478078] wlan1: RX deauthentication from 00:...
[226013.480571] wlan1: associated
[227212.487556] wlan1: RX deauthentication from 00:...
[227213.489715] wlan1: associated
[228412.497499] wlan1: RX deauthentication from 00:...
[228413.496655] wlan1: associated
[229101.490133] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[229165.490136] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[229191.490159] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[229612.508539] wlan1: RX deauthentication from 00:...
[229613.506668] wlan1: associated
[232289.500159] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[238241.500151] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[238413.500163] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range

That brings us up-to-date and I'm still online and I've needed to
do nothing to remain that way.

In the worst case so far, this occurred twice within ten seconds.
There's no obvious predictability as to when the ProbeResp fails.

Ignoring it, as I've done, is not the right way to proceed, but
unless I either read the code or add further debugging, I can't
say whether a few retries would help me, or if I should simply
await the inevitable timeouts which I assume happen later.


This probably isn't a problem with a strong local net, or perhaps
an isolated net without other potentially-interfering APs, but I
know too little about wireless networking protocols and modulation
techniques to speak authoritatively.


*update*
Ah, now we have a weak signal: seems to be 4 to 6 second intervals
between syslog messages, and again I'm back in business...  aaaand,
I'm out of range, but still see signal levels -- no syslog-bombing
as feared; signal unusable, syslog has stopped, awaiting usual kernel
panic, nothing yet, ...

Yay!  Third complaint about mac80211 is identified (an ``unusable''
signal would disappear from /proc/net/wireless so I was no longer
able to monitor it easily to determine when it was safe to attempt
to reassociate and continue...)

And in spite of all this, I've automagically reassociated and
can ping the AP, even after tens of minutes of weak signal


I conclude that the above code might be useful or necessary for
wardriving, where a fading AP might be replaced by something better,
but for war-settin'-on-me-arse it introduces obstacles; even for
war-I-have-an-AP-and-I-ain't-afraid-to-use-it there may well be
problems through reinforced concrete walls or in large cities/
housing concentrations with lotsa WLANs all on the same channel.


[much time passes]

And some hours later, I've lost my association but nevertheless the
signal quality remains available through /proc/net/wireless, which
hints that I can successfully reassociate, and indeed that is the
case, after a few hours of sleep and heavy rain.  Joy oh joy.

Further dmesg scraps:
[252413.906181] wlan1: associated
[252437.900171] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[252473.900150] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[252489.900164] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[252507.900156] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[252767.900142] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[252771.900155] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[...]
[253999.900163] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[254003.900221] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[254007.900151] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[254011.900322] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[254015.900224] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[254019.900163] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[254023.900146] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[time passes, I sleep, with open window, kitchen flooded, etc. etc.]
[I wake up, ping fails, I manually reassociate to do further ``work''...]
[266211.365705] wlan1: Initial auth_alg=0
[266211.365705] wlan1: authenticate with AP 00:...
[266211.370105] wlan1: associated
[further messages as I'm writing this:]
[268233.380152] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[268239.380144] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[268443.380153] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range
[268525.380158] wlan1: No ProbeResp from current AP 00:[CENSORED] - assume out of range

Connection still works and all so far.  Draw your own conclusions.

At worst this message is logged every four seconds, the time when I'm
asleep and presumably the remote AP is indeed unreachable.  After this,
some sort of natural decay takes place and the connection becomes stale,
yet with my hack, I'm still able to readily monitor signal quality.

Had I been wanting to download pr0n^W^W work this last hour since
waking (not a typo), I would have been kicked off some six times
and I might have decided to mop up the kitchen instead.


thanks,
barry bouwsma


      

