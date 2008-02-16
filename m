Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYBPMEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYBPMEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 07:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYBPMDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 07:03:50 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:39841 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYBPMDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 07:03:49 -0500
Message-ID: <47B6D11F.8060304@tiscali.nl>
Date: Sat, 16 Feb 2008 13:03:43 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       hidave.darkstar@gmail.com
Subject: Re: + bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc.patch added
 to -mm tree
References: <200802160449.m1G4nX5V009024@imap1.linux-foundation.org>	<20080216.012741.243894500.davem@davemloft.net> <20080216015442.e94dc0ca.akpm@linux-foundation.org>
In-Reply-To: <20080216015442.e94dc0ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 16 Feb 2008 01:27:41 -0800 (PST) David Miller <davem@davemloft.net> wrote:
> 
>> From: akpm@linux-foundation.org
>> Date: Fri, 15 Feb 2008 20:49:33 -0800
>>
>>> Subject: bluetooth: fix warning in net/bluetooth/hci_sysfs.c
>>> From: Andrew Morton <akpm@linux-foundation.org>
>>>
>>> net/bluetooth/hci_sysfs.c: In function 'del_conn':
>>> net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assignment used as truth value
>>>
>>> Cc: Dave Young <hidave.darkstar@gmail.com>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Linus barfed when this exact patch got posted a few weeks
>> ago, he said he considers just adding parenthesis to quiet
>> this warning awful and explicit NULL test should be used.
> 
> -	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
> +	while ((dev = device_find_child(&conn->dev, NULL, __match_tty))) {
> 
> hrm.
> 
> box:/usr/src/linux-2.6.25-rc2> grep -r 'while [(][(].*{$' . | wc -l               
> 1240
> box:/usr/src/linux-2.6.25-rc2> grep -r 'while [(][(].*{$' . | grep -v NULL | wc -l
> 867
> 
> so two thirds of them presently don't bother testing for NULL.  It's a
> pretty common idiom.
> 
> (adds the != NULL, sees that it reaches column 82, drops patch in disgust)

Not my results:

# greps for 'while ((x = y(...)))' see below for variables

git-grep -n -A2 "while" | 
sed -n "s/^\([^\.]*\.[chsS]-[0-9]*-\|\([^\.]*\.[chsS]:[0-9]*:\)$s\)\(.*\)$/\2\3/p" |
tr "\n" "@" |
grep -o "@[^@]*while$z($z($z$W$z=$z$W$z($h)$z)$z)" |
tr "@\t" " " | tr -s " " | wc -l
262

# while ((x = y(...)) != NULL)

git-grep -n -A2 "while" | 
sed -n "s/^\([^\.]*\.[chsS]-[0-9]*-\|\([^\.]*\.[chsS]:[0-9]*:\)$s\)\(.*\)$/\2\3/p" |
tr "\n" "@" |
grep -o "@[^@]*while$z($z($z$W$z=$z$W$z($h)$z)$z\!=${z}NULL$z)" |
tr "@\t" " " | tr -s " " | wc -l
333

# while ((x = y(...)) != 0)

git-grep -n -A2 "while" | 
sed -n "s/^\([^\.]*\.[chsS]-[0-9]*-\|\([^\.]*\.[chsS]:[0-9]*:\)$s\)\(.*\)$/\2\3/p" |
tr "\n" "@" |
grep -o "@[^@]*while$z($z($z$W$z=$z$W$z($h)$z)$z\!=${z}0$z)" |
tr "@\t" " " | tr -s " " | wc -l
45

# while (!(x = y(...)))

git-grep -n -A2 "while" | 
sed -n "s/^\([^\.]*\.[chsS]-[0-9]*-\|\([^\.]*\.[chsS]:[0-9]*:\)$s\)\(.*\)$/\2\3/p" |
tr "\n" "@" |
grep -o "@[^@]*while$z($z\!$z($z$W$z=$z$W$z($h)$z)$z)" |
tr "@\t" " " | tr -s " " | wc -l
19


V="[A-Za-z_]\+[A-Za-z0-9_]*"
W="$V\(\[$V\]\|\[[0-9]\+\]\|\.$V\|->$V\)*"
s="[[:space:]]*"
h="[^()]*\(([^()]*)[^()]*\)*"
z="[@[:space:]]*"
