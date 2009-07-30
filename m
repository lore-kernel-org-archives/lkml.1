Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZG3TV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZG3TV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZG3TV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:21:27 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35146 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZG3TVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oXg/M57KbAgfnHaP9oEmN7Ls6wW1THHe+W4tFec6GyAI/FCd+X/7w3B5LOefmfO8ZN
         IPc05Tgu5mUKjoDF9vcI7KnEoeidScxrNKL5WKgntyl7zGoOs6feFV0aAM8Nhu9ifJzw
         OhRvXXoaefzxDHyELdOccCK5NjjaIiV23cpNU=
MIME-Version: 1.0
In-Reply-To: <20090729145839.GB15102@csn.ul.ie>
References: <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com>
	 <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com>
	 <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com>
	 <4A6F2AF4.6050505@gmail.com>
	 <alpine.DEB.2.00.0907281401150.7140@chino.kir.corp.google.com>
	 <4A6F8115.7000500@gmail.com>
	 <20090728165245.65d5cb23.akpm@linux-foundation.org>
	 <7928e7bd0907281700s13d9937yc3b2933b13cfae9f@mail.gmail.com>
	 <20090729145839.GB15102@csn.ul.ie>
Date: Thu, 30 Jul 2009 12:21:23 -0700
Message-ID: <7928e7bd0907301221v73b050e4hbc91bf08ddf07248@mail.gmail.com>
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped 
	vma clearing
From: Moussa Ba <moussa.a.ba@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, xiyou.wangcong@gmail.com, adobriyan@gmail.com,
       mpm@selenic.com, yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,

here are two scripts that make use of the interface to "measure"
Referenced anon vs. mapped pages.

save the awk script to refs.awk  and run the bash script as follows

./refscount PID secs

PID is the process you want to monitor while secs is the number of
seconds to sleep before clearing the refs.    The output after x secs
is a the total number of refs before and immediately after clearing.
Here is an example run using firefox as I was writing this email.

/usr/lib/firefox-3.0.3/firefox
12:10:58 Mapped = 12856 kB Anon = 27896 kB
12:10:58 Mapped = 760 kB Anon = 4 kB
12:11:08 Mapped = 5884 kB Anon = 20340 kB
.
.
.
.
12:16:19 Mapped = 476 kB Anon = 0 kB
12:16:29 Mapped = 7016 kB Anon = 13128 kB
12:16:29 Mapped = 476 kB Anon = 0 kB
12:16:39 Mapped = 9276 kB Anon = 21588 kB
12:16:39 Mapped = 476 kB Anon = 0 kB
12:16:49 Mapped = 10288 kB Anon = 16000 kB
12:16:49 Mapped = 716 kB Anon = 12 kB

BEGIN BASH SCRIPT
--------------------------------
#!/bin/bash

echo `cat /proc/$1/cmdline`
#Intial state of the process
cat /proc/$1/smaps | awk -f refs.awk

while [ true ]
do
    echo 1 > /proc/$1/clear_refs
    # Immidiately after clearing
    cat /proc/$1/smaps | awk -f refs.awk
    sleep $2
    # after x seconds
    cat /proc/$1/smaps | awk -f refs.awk
done
---------------------------
END BASH SCRIPT

BEGIN AWK SCRIPT
-----------------------

BEGIN {refsanon = 0;refsmapped=0;}

{
    if (NF == 6)  {
	if ($4 == "00:00")
	    type = 1;
	else
	    type = 2;
    }

    if ($1 == "Referenced:") {
	if (type == 1)
	    refsanon += $2;
	if (type == 2)
	    refsmapped += $2;
	type = 0;
    }

}
END {printf("%s ",strftime("%H:%M:%S"));  print "Mapped = " refsmapped
" kB Anon = " refsanon " kB";}

---------------------------
END AWK SCRIPT


On Wed, Jul 29, 2009 at 7:58 AM, Mel Gorman<mel@csn.ul.ie> wrote:
> On Tue, Jul 28, 2009 at 05:00:54PM -0700, Moussa Ba wrote:
>> The patch makes the clear_refs more versatile in adding the option to
>> select anonymous pages or file backed pages for clearing.  This
>> addition has a measurable impact on user space application performance
>> as it decreases the number of pagewalks in scenarios where one is only
>> interested in a specific type of page (anonymous or file mapped).
>>
>
> I think what Andrew might be looking for is a repeat of the use-case for
> using clear_refs at all and what the additional usecase is that makes this
> patch beneficial. To be honest, I had to go digging for a bit to find out
> why clear_refs is used at all and the potential benefits of this patch were
> initially unclear to me although they were obvious to others. I confess I
> haven't read the patch closely to determine if it's behaving as advertised
> or not.
>
> Bonus points for a wee illustration of a script that measures the apparent
> working set of a process using clear_refs, showing the working set for anon
> vs filebacked and the difference of measuring just anon versus the full
> process for example. Such a script could be added to Documentation/vm as
> I didn't spot any example in there already.
>
> Total aside, is there potential to really mess with LRU aging by abusing
> clear_refs a lot, partcularly as clear_refs is writable by the process
> owner? Does it matter?
>
>>
>> On Tue, Jul 28, 2009 at 4:52 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>> > On Tue, 28 Jul 2009 15:52:05 -0700
>> > "Moussa A. Ba" <moussa.a.ba@gmail.com> wrote:
>> >
>> >> This patch adds anonymous and file backed filters to the clear_refs interface.
>> >> echo 1 > /proc/PID/clear_refs resets the bits on all pages
>> >> echo 2 > /proc/PID/clear_refs resets the bits on anonymous pages only
>> >> echo 3 > /proc/PID/clear_refs resets the bits on file backed pages only
>> >> Any other value is ignored
>> >
>> > The changelog is missing any rationale for making this change.
>> > Originally we were told that it "makes the clear_refs proc interface a
>> > bit more versatile", but that's a bit thin.
>> >
>> > How do we justify making this change to Linux?  What value does it
>> > have?  Can you describe a usage scenario which would help people
>> > understand the usefulness of the change?
>> >
>> > Thanks.
>> >
>>
>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>
