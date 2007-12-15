Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbXLOWoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbXLOWoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 17:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXLOWoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 17:44:13 -0500
Received: from science.horizon.com ([192.35.100.1]:16864 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752466AbXLOWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 17:44:12 -0500
Date: 15 Dec 2007 17:44:06 -0500
Message-ID: <20071215224406.1591.qmail@science.horizon.com>
From: linux@horizon.com
To: jreiser@BitWagon.com, linux-kernel@vger.kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Cc: linux@horizon.com, tytso@mit.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> There is a path that goes from user data into the pool.  This path
>> is subject to manipulation by an attacker, for both reading and
>> writing.  Are you going to guarantee that in five years nobody
>> will discover a way to take advantage of it?  Five years ago
>> there were no public attacks against MD5 except brute force;
>> now MD5 is on the "weak" list.

> Yep, I'm confident about making such a guarantee.  Very confident.

For the writing side, there's a far easier way to inject potentially
hostile data into the /dev/random pool:
	"echo evil inentions > /dev/random".

This is allowed because it's a very specific design goal that an attacker
cannot improve their knowledge of the state of the pool by feeding in
chosen text.

Which in turn allows /dev/random to get potential entropy from lots of
sources without worrying about how good they are.  It tries to account
for entropy it's sure of, but it actually imports far more - it just
don't know how much more.

One of those "allowed, but uncredited" sources is whatever you want to
write to /dev/random.

So you can, if you like, get seed material using
wget -t1 -q --no-cache -O /dev/random 'http://www.fourmilab.ch/cgi-bin/Hotbits?fmt=bin&nbytes=32' 'http://www.random.org/cgi-bin/randbyte?nbytes=32&format=f' 'http://www.randomnumbers.info/cgibin/wqrng.cgi?limit=255&amount=32' 'http://www.lavarnd.org/cgi-bin/randdist.cgi?pick_num=16&max_num=65536'

I don't trust them, but IF the data is actually random, and IF it's not
observed in transit, then that's four nice 256-bit random seeds.

(Note: if you actually use the above, be very careful not to abuse these
free services by doing it too often.  Also, the latter two actually
return whole HTML pages with the numbers included in ASCII.  If anyone
knows how to just download raw binary, please share.)
