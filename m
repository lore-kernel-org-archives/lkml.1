Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbZASMSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbZASMSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbZASMSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:18:14 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50220 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbZASMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:18:13 -0500
Date: Mon, 19 Jan 2009 13:18:10 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: install to a single directory
In-Reply-To: <20090119111745.404e2794@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LSU.2.00.0901191228460.12961@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901172055100.15992@fbirervta.pbzchgretzou.qr> <20090119111745.404e2794@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-01-19 02:24, Sam Ravnborg wrote:
>On Sun, Jan 18, 2009 at 10:17:16PM +0100, Jan Engelhardt wrote:
>> 
>> This proposed change will collect all kernel modules in the
>> single directory, e.g. /lib/modules/2.6.29-rc2/kernel/, without
>> any further directory structure. About 475 inodes (with
>> almost-allmodconfig) less are used, which should result
>> in faster directory traversal (less seeks).
>
>Can you elaborate a little more why this is needed / a good thing.

|[Alan Cox wants the numbers, too]

# File sizes (LZMA'ed RPM payload, but archive contains .ko.gz, so
# it is so-so~~)
-rw-r--r-- 1 31090287 Jan 19 10:51 kernel-2.6.29~rc2.i586.rpm
-rw-r--r-- 1 31031150 Jan 17 23:39 kernel-SingleDir-2.6.29~rc2.i586.rpm

# fs barriers are turned off (got an UPS)
# /tmp is XFS, on a 5400rpm disk on a 2003ish Athlon4 system, 768MB RAM

# installing rpm
md /tmp/test1/var/lib/rpm/;
for ((i = 0; i < 5; ++i)); do
	rm -Rf /tmp/test1/var/lib/rpm/*;
	rpm --root /tmp/test1 --initdb;
	sync; echo 3 >/proc/sys/vm/drop_caches;
	time ( rpm --root /tmp/test1 -ihv kernel-2.6.29~rc2.i586.rpm \
		--nodeps --noscripts; sync; );
done

# kernel-2.6.29~rc2.i586.rpm
real	31.778	33.205	32.076	32.451	33.576
user	6.227	6.274	6.159	6.216	6.290
sys	1.837	1.806	1.888	1.890	1.843

# kernel-SingleDir-2.6.29~rc2.i586.rpm
real	18.666	19.257	19.013	19.257	19.280
user	6.222	6.225	6.232	6.245	6.270
sys	1.900	2.178	2.181	2.183	2.263

# running gzip -d for all .ko.gz
# running depmod
for ((i = 0; i < 5; ++i)); do
	sync; echo 3 >/proc/sys/vm/drop_caches;
	depmod -b /tmp/test1 -r 2.6.29-rc2;
done;

# depmod on kernel
real	32.256	32.242	32.275	32.392	32.529
user	2.004	2.029	2.034	2.051	1.963
sys	0.808	0.842	0.824	0.826	0.847

# depmod on kernel-SingleDir
real	21.062	19.293	19.326	19.411	19.361
user	1.691	1.693	1.660	1.724	1.760
sys	0.761	0.766	0.784	0.767	0.750


>Also:
>-> Is mod-utils compatible with this change

Yes, module-init-tools does not care about the directory layout --
how could it? If it depended such, m-i-t would have to be
adjusted on about every single new subsystem/directory that
is added.

>-> Is userland in general compatible with this change

More so than the .gz stuff, I'd say.
