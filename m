Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbXHBX14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbXHBX14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbXHBX1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:27:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48530 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbXHBX1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:27:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B26860.2000705@s5r6.in-berlin.de>
Date: Fri, 03 Aug 2007 01:27:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange> <46B25B5E.30406@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030046230.6774@poirot.grange> <20070802230914.GT21089@ftp.linux.org.uk>
In-Reply-To: <20070802230914.GT21089@ftp.linux.org.uk>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Fri, Aug 03, 2007 at 12:51:16AM +0200, Guennadi Liakhovetski wrote:
>> On Fri, 3 Aug 2007, Stefan Richter wrote:
>>
>>> Guennadi Liakhovetski wrote:
>>>> with
>>>>
>>>> 	char c[4] = "012345";
>>>>
>>>> the compiler warns, but actually allocates a 6-byte long array...
>>> Off-topic here, but:  sizeof c / sizeof *c == 4.
>> Don't think it is OT here - kernel depends on gcc. And, what I meant, is, 
>> that gcc places all 7 (sorry, not 6 as I said above) characters in the 
>> .rodata section of the compiled object file. Of course, it doesn't mean, 
>> that c is 7 characters long.
> 
> So gcc does that kind of recovery, after having warned you.  Makes sense,
> as long as it's for ordinary variables (and not, say it, struct fields) -
> you get less likely runtime breakage on the undefined behaviour (e.g.
> passing c to string functions).  So gcc has generated some padding between
> the global variables, that's all.

No, the fact that the full 012345\0 ends up in the object file is
apparently unrelated to what happens to the variable c...

> It doesn't change the fact that use of c[4] or strlen(c) or strcpy(..., c)
> means nasal demon country for you.
> 
> Now, if gcc does that for similar situation with struct fields, you'd have
> a cause to complain.

...since only 0123 will get into c at runtime, i.e. a 4 bytes long array
without \0 appendix or other extraordinary padding.

#include <stdio.h>
#include <string.h>

int main()
{
	char c[4] = "012345";

	printf("%d %d _%s_\n", sizeof c / sizeof *c, strlen(c), c);
	return 0;
}

$ ./a.out
4 8 _01230®¿_

$ strings a.out |grep 0123
012345

-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
