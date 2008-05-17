Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYEQVER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYEQVER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbYEQVEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:04:02 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:60941 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908AbYEQVEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:04:00 -0400
Date: Sat, 17 May 2008 23:03:26 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: hibernate event order question
Message-ID: <20080517210325.GB3675@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
References: <20080517175046.GA9032@yamamaya.is-a-geek.org> <200805172156.12686.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805172156.12686.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> > Now for my question:
> > AFAICS the ordering of events is as follows:
> > 1) User reqests hibernate
> > 2) Tasks are frozen
> > 3) Device suspend callbacks get called
> > 4) Device resume callbacks get called
> > 5) Memory image is written to disk
> 
> 6) Device suspend callbacks get called again to prepare for the system sleep
>    state.

Hmm, I guess I don't see that because by then the console is disabled or
something like that?
(It also doesn't help that the system immediately powers down after that)
Can I get debugging output during that phase out onto the serial
console and/or plain text console & simply turn the poweroff into a
halt? (halt in addition to shutdown and reboot in /sys/power/disk
might be nice)

The problem is I'm really seeing/have seen multiple issues/situations here:
1) When the device is part of a bridge, connectivity is down after
   Hibernate
2) Boot->Hibernate->WOL works->Hibernate->WOL only works with
   byte-reversed MAC-address
3) I have to reconfirm this, but I think after fixing bug 1) with
   the patch of the previous mail bug 2) turns into 4):
4) WOL doesn't work at all after Hibernate
5) nforce ethernet and netgear switch don't like each other and
   sometimes negotiate only 100Mbit instead of 1Gbit, while my
   notebook on a much longer cable never has negotiation problems
6) In the past sometimes negotiation would take very long, that one
   I haven't seen in some time so I assume it's fixed in recent
   kernels.  This one only happened if both ports were enabled IIRC

"Device suspend callbacks get called again" means I have to retest 3)
Maybe I'm imagining things or seeing a heisenbug here?

1) Is fixed by the patch in the previous mail
2) I assume to be related to DEV_HAS_CORRECT_MACADDR,
NVREG_TRANSMITPOLL_MAC_ADDR_REV and some magic byteswapping code in
the driver.
1) and 2)/4) can be worked around (for the bridge case) by removing
the forcedeth module prior to hibernate and reinserting the module
and readding the devices to the bridge after resume.

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
