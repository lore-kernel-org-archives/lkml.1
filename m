Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbXEINV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbXEINV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXEINVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:21:50 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:33719 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbXEINVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:21:49 -0400
Message-ID: <4641CAAF.8060103@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 15:20:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: ego@in.ibm.com
CC: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, rjw@sisk.pl,
       James.Bottomley@SteelEye.com, aneesh.kumar@gmail.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, greg@kroah.com, mingo@elte.hu, neilb@suse.de,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, vatsa@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 128/197] freezer: add try_to_freeze calls to all kernel
 threads
References: <200705090934.l499YTvX019783@shell0.pdx.osdl.net> <4641A5F1.5080901@s5r6.in-berlin.de> <20070509104949.GA8164@elf.ucw.cz> <4641B92D.1030909@s5r6.in-berlin.de> <20070509121641.GA27109@in.ibm.com>
In-Reply-To: <20070509121641.GA27109@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> freezer_exempt() as of now does what its name says. I.e, exempt the
> thread from all kinds of freeze chills.
> 
> But with more subsystems using the process freezer, the exemption needs
> to be event specific. There may be threads which should not be frozen 
> for say kprobes, should be frozen for cpu-hotplug. This selective
> freezing is not yet available. But it will be soon...

Thanks for the (necessary!) clarification.
Let me point out that the usual process would be to replace

	freezer_exempt(current);
	for (;;) {
		...;
by
	freezer_exempt_for_io(current);
	for (;;) {
		try_to_freeze();
		...;

when or after freezer_exempt_for_io was implemented.

But as it was submitted now, we are temporarily left with

	freezer_exempt(current);
	for (;;) {
		try_to_freeze();  /* useless irritating no-op */
		...;

without any benefit.  (And this explanatory comment ^^^ wasn't even
added; we only have the git log as explanation.)

As subsystem maintainer I have to trust now that "soon" actually means
"soon" and not "RSN"; otherwise my responsibility would be to send a NAK.
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
