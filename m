Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbXBBInP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbXBBInP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933324AbXBBInP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:43:15 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:23014 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933322AbXBBInO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:43:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=XM4e00r12Z+6BRJL3z9ir4njWWuDrm2RmQO/vOxguvkQAh4ftyqEhYWRc1e3MM2XXHtGdxfJC0Y3ucKqJ6g/KUbnH/QF3IxZOMwg7UjEnQh0p4q7q9GLRj9IvuBK5eqHMvMJKWsb+YZdFCtyMd43MEkMW3XWRdr4DdkIig7Xcvg=  ;
X-YMail-OSG: JmEb0b4VM1llQkmXNcBsFq_OjnxAAYBgMmIMvkmq4F9clixkrzGtKxtpXXZ2yjFJRle7g112ChHavoHdIQ.L8aFlz3J9AzCoukZ9ISwnGJn2VKzT_mOsGjj3Hmw7J1kGIc0WplLGtrt.RNxIP6Q.GrkKFooVplymdiZRCWkBpOqAIFXfV7Vjd3MS7EqW
Message-ID: <45C2F98C.3070000@yahoo.com.au>
Date: Fri, 02 Feb 2007 19:42:52 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mark Groves <mjgroves@uwaterloo.ca>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mm: fix page_mkclean_one
References: <1170369622.3453.72.camel@garangu>
In-Reply-To: <1170369622.3453.72.camel@garangu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Groves wrote:
> Hi,
> 
> 
> I have been been seeing a problem when using sendfile repeatedly on an
> SMP server, which I believe is related to the problem that was
> discovered recently with marking dirty pages. The bug, as well as a test
> script, is listed at http://bugzilla.kernel.org/show_bug.cgi?id=7650.
> Currently, we're experiencing errors where part of a previous packet is
> being sent out rather than the current packet.
> 
> I have applied the patch Linus posted to a 2.6.19 kernel but am still
> getting the problem. So I am wondering if there are any other places in
> the kernel which mark pages as dirty which might require a similar
> patch?

Your issue is not related, firstly because the page_mkclean bug did not
exist before 2.6.19 kernels.

Anyway, I had a look at your bugzilla test-case and managed to slim it
down to something that easily shows what the problem is (available on
request) -- the problem is that recipient of the sendfile is seeing
modifications that occur to the source file _after_ the sender has
completed the sendfile, because the file pages are not copied but
queued.

I think the usual approach to what you are trying to do is to set TCP_CORK,
then write(2) the header into the socket, then sendfile directly from the
file you want.

Another approach I guess is to implement an ack in your userland protocol
so you do not modify the sendfile source file until the client acks that
it has all the data.

I'm not sure if there are any other usual ways to do this (ie. a barrier
for sendfile, to ensure it will not pick up "future" modifications to the
file). netdev cc'ed, someone there might have additional comments.

Please close this bug if/when you are satisfied it is not a kernel problem.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
