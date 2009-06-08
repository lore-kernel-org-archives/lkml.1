Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZFHSCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZFHSCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZFHSCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:02:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51460 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZFHSCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:02:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A2D51E6.6030607@s5r6.in-berlin.de>
Date: Mon, 08 Jun 2009 20:01:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Pranith Kumar <pranith.hacks@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
References: <4A2CBB99.9080908@gmail.com> <4A2CC6FA.6020904@gmail.com> <4A2CD560.8070002@s5r6.in-berlin.de> <4A2CE1A6.9000501@gmail.com>
In-Reply-To: <4A2CE1A6.9000501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar wrote:
> Stefan Richter wrote:
...
>> This code uses defined types which are foreign to Linux.  We don't
>> define UCHAR in Linux.  /This/ needs to be fixed in the entire driver.
>> Until this is not done, there is no reason to add this pointer type cast
...
> Thanks for your comment. Going through the header, I found the following
> defines
> 
> typedef unsigned char		UINT8;
> typedef unsigned short		UINT16;
...
> Now if I delete all these defines and do a search and replace for those
> types, is it OK?
> 
> There might be an argument that the current state is much cleaner. 

Plain C's unsigned char and friends should be preferred.  Pointer types 
like PVOID should be replaced by straight-forward "void *" and so on, 
and BOOLEAN can be replaced by "bool" (with "true" and "false" as 
possible values).

In cases where the particular size of variables or struct members 
matters, there are u8, s16 etc. available.

Furthermore, when variables don't represent CPU endian (host endian) 
data but actually big endian or little endian, then we annotate the 
types with __be32, __le32 etc..  *However*, adding these endian 
annotations (*if* the driver in question has to deal with endianess 
other than CPU) should usually better be done in another separate patch 
or series of patches.  This is because the process of adding the endia 
annotations has a chance of unveiling sloppy or non-protable or even 
buggy code, and then some more intensive and non-trivial work on the 
code will be required.

Lastly, if there is a binary interface to userspace (e.g. character 
device file interface), then we use types like __u32 in header files 
which are going to be used by userspace programs.

Now, the type replacement will of course shuffle the text flow (line 
lengths...), so the question will arise whether to adjust whitespace 
(line wraps) in the same patch set.  However, the code which you looked 
at also has other trivial deviations from kernel style.  Notably, the 
use of CamelCase names rather than all-lowercase with underscores. 
Example:  Something like pClonedPkt should become p_cloned_pkt or better 
p_cloned_packet or cloned_packet (if the p prefix didn't mean anything 
else than that it was a pointer), or if it is clear from context, 
something brief like cp.

Such style adjustments also need to happen; if you are interested in 
doing that, then you can plan ahead and hold off with whitespace 
adjusting changes (indentation, line wraps...) until after you did those 
other changes regarding type names and variable/ function/ macro names.

In any case, before starting some bigger style adjustments, check the 
TODO file of the respective staging driver and notify Greg and 
devel@linuxdriverproject.org, so that clashes with ongoing work by 
others can be avoided.

Moreover, you should probably _not_ start such work on wireless drivers 
in staging like rt2860.  See the notes in the TODO files of these 
drivers; the real work is going on at other drivers for the same 
hardware in the normal Linux wireless development tree.
-- 
Stefan Richter
-=====-==--= -==- -=---
http://arcgraph.de/sr/
