Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbZFAUjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbZFAUjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZFAUjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:39:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:43347 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbZFAUjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HuZNMs2PSyEPhwotl4vZXXQWW5AYcHYy3rf+MbITLgZdyWsVaWRjVWW2QnvGDugTvK
         nTxXsSAwb9swRJrHc2Vuk5eQWunOK5dp/B+ipylFU7MmYOhfm0inVAsuFjfHrOEGGNUq
         SFXncrGG/yaJdalR83EeX0IewcbBug9G6lqZM=
MIME-Version: 1.0
In-Reply-To: <1243885732.22069.112.camel@calx>
References: <200906011526.01108.rgetz@blackfin.uclinux.org>
	 <1243885732.22069.112.camel@calx>
Date: Mon, 1 Jun 2009 16:39:10 -0400
Message-ID: <8bd0f97a0906011339u37058082wcc187417dcc78d67@mail.gmail.com>
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
From: Mike Frysinger <vapier.adi@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, Sam Ravnborg <sam@ravnborg.org>,
       Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 1, 2009 at 15:48, Matt Mackall wrote:
> On Mon, 2009-06-01 at 15:26 -0400, Robin Getz wrote:
>> --- scripts/bloat-o-meter     (revision 6437)
>> +++ scripts/bloat-o-meter     (working copy)
>> @@ -9,18 +9,37 @@
>>
>>  import sys, os, re
>>
>> -if len(sys.argv) != 3:
>> +def usage():
>>      sys.stderr.write("usage: %s file1 file2\n" % sys.argv[0])
>>      sys.exit(-1)
>>
>> +if len(sys.argv) < 3:
>> +    usage()
>> +
>> +for f in sys.argv[1], sys.argv[2]:
>
> in sys.argv[1:3]:  is a bit more standard
>
> But this test should instead happen inside getsizes, no loop needed.
>
>> +    if not os.path.exists(f):
>> +        sys.stderr.write("Error: file '%s' does not exist\n" % f)
>> +        usage()
>> +
>> +nm_args = " ".join([x for x in sys.argv[3:]])
>
> nm_args = " ".join(sys.argv[3:])

ive made the argv changes in busybox upstream

>>  def getsizes(file):
>>      sym = {}
>> -    for l in os.popen("nm --size-sort " + file).readlines():
>> -        size, type, name = l[:-1].split()
>> -        if type in "tTdDbB":
>> +    for l in os.popen("nm --size-sort %s %s" % (nm_args, file)).readlines():
>> +     l = l.strip()
>> +     # Skip empty lines
>> +        if not len(l): continue
>
> (seems to be some whitespace damage? there should be no tabs in this
> source)

fixed the whitespace damage (all spaces)

>>  old = getsizes(sys.argv[1])
>> @@ -53,8 +72,10 @@
>>  delta.sort()
>>  delta.reverse()
>>
>> -print "add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
>> -      (add, remove, grow, shrink, up, -down, up-down)
>> -print "%-40s %7s %7s %+7s" % ("function", "old", "new", "delta")
>> +print "%-48s %7s %7s %+7s" % ("function", "old", "new", "delta")
>>  for d, n in delta:
>> -    if d: print "%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
>> +    if d: print "%-48s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
>> +print "-"*78
>> +total="(add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s)%%sTotal: %s
>> bytes"\
>> +    % (add, remove, grow, shrink, up, -down, up-down)
>> +print total % (" "*(80-len(total)))
>
> Not terribly excited about this last bit, which is going out of its way
> to right-align the total? Who cares about that?

it makes things a lot easier to read, especially in commit scripts

as for the rest of your comments, Denis or Rob can tackle those
-mike
