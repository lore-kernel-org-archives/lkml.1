Return-Path: <linux-kernel-owner+w=401wt.eu-S934413AbXGTVBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934413AbXGTVBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762684AbXGTVBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:01:38 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1300 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508AbXGTVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:01:37 -0400
Date: Fri, 20 Jul 2007 22:29:11 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] totally hanging altough not crashed
Message-ID: <20070720202911.GK25317@vanheusden.com>
References: <20070720195252.GA25317@vanheusden.com> <46A11E7D.90209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A11E7D.90209@redhat.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Jul 21 21:41:40 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > One of my systems running 2.6.21.1 on a P4 with HT and 2GB of ram
> > occasionally crashes. Not with an oops or panic, it just suddenly stops
> > doing anything. It still lets you ping and it still forwards ip traffic
> > but you can't login: not via ssh and not on the console - pressing enter
> > brings the cursor to the next line and that's it. It is NOT swapping at
> > all, in fact alt+sysrq+m says that there's still plenty of memory and
> > swap available:
> 
> Lots of processes are in uninterruptible wait at
> start_this_handle+0x208/0x365. Can you find out what line of code
> that matches? (There are a few of those waits in that function.)

I did some more investigating and found:

folkert@muur:~$ grep -A 1 "Call Trace" www/ast.txt | grep -v -e "^--" -v -e "Call Trace:" | cut -d " "  -f 2- | genstats | more
    1   358     54.82%     1.75  [<c120f326>] schedule_timeout+0x8c/0x8e
    2    88     13.48%     7.42  [<c10c23a0>] start_this_handle+0x208/0x365
    3    63      9.65%    10.10  [<c120f2e0>] schedule_timeout+0x46/0x8e
    4    36      5.51%    17.69  [<c1020868>] do_wait+0x2c4/0x396
    5    36      5.51%    16.81  [<c1098cbd>] inotify_read+0x8d/0x1b5
    6    17      2.60%    37.59  [<c1074f52>] pipe_wait+0x8a/0xab
    7    13      1.99%     2.69  [<c102d22e>] worker_thread+0x130/0x165
    8    11      1.68%    55.73  [<c1210307>] do_nanosleep+0x42/0x70
    9     7      1.07%    92.29  [<c120f5e9>] __mutex_lock_slowpath+0xac/0x28c
   10     7      1.07%    90.71  [<c101f9fc>] do_exit+0x253/0x428
   11     2      0.31%   145.50  [<c1138101>] write_chan+0x15b/0x1d6
   12     2      0.31%     3.50  [<c104de2a>] watchdog+0x47/0x55
   13     2      0.31%     3.00  [<c10224f6>] ksoftirqd+0x85/0x98
   14     2      0.31%     2.50  [<c1018e44>] migration_thread+0x8a/0x10f
   15     1      0.15%   617.00  [<c10c7d56>] log_wait_commit+0xb5/0x121
   16     1      0.15%   562.00  [<c1029e46>] sys_pause+0x14/0x1b
   17     1      0.15%   225.00  [<f8a58ae1>] schluffen+0xad/0xaf [zaptel]
   18     1      0.15%    63.00  [<c1029efc>] sys_rt_sigsuspend+0xaf/0xcf
   19     1      0.15%    23.00  [<c10c75ff>] kjournald+0x1fd/0x207
   20     1      0.15%    22.00  [<c10c4b6f>] journal_commit_transaction+0x242/0xcd3
   21     1      0.15%    17.00  [<c105ab1b>] kswapd+0xf7/0x10b
   22     1      0.15%    16.00  [<c1191647>] serio_thread+0xfa/0xff
   23     1      0.15%    15.00  [<c11730e7>] hub_thread+0xe6/0xe8

(please ignore the fourth column)

As I'm not entirely sure that this an innocent to be in for a kernel I
put this point into gdb:

(gdb) p schedule_timeout
$1 = {long int (long int)} 0xc121a8b4 <schedule_timeout>
(gdb) l *0xC120F3B2
0xc120f3b2 is in __xfrm_state_insert (net/xfrm/xfrm_hash.h:49).
44      static inline unsigned __xfrm_src_hash(xfrm_address_t *daddr,
45                                             xfrm_address_t *saddr,
46                                             unsigned short family,
47                                             unsigned int hmask)
48      {
49              unsigned int h = family;
50              switch (family) {
51              case AF_INET:
52                      h ^= __xfrm4_daddr_saddr_hash(daddr, saddr);
53                      break;

I very much hope it is of any help.


Folkert van Heusden

-- 
www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
HP/UX en win een vlaai naar keuze
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
