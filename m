Return-Path: <linux-kernel-owner+w=401wt.eu-S1031364AbXDJSQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031364AbXDJSQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031366AbXDJSQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:16:50 -0400
Received: from Apollo.christiedigital.com ([65.195.57.9]:36974 "EHLO
	CDSCYPEXG01.cds.int" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031364AbXDJSQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:16:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Help Understanding Linux memory management
Date: Tue, 10 Apr 2007 14:17:00 -0400
Message-ID: <AD98412A5373CC4AA643D9C021922A541C4DCB@cdskitexg01.cds.int>
In-Reply-To: <20070410171631.4844afe8@the-village.bc.nu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Help Understanding Linux memory management
Thread-Index: Acd7izmvPXssZ3dJRwu5O9pdJUEiZAABIh7Q
From: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Robert Hancock" <hancockr@shaw.ca>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Apr 2007 18:17:01.0983 (UTC) FILETIME=[6F8ACAF0:01C77B9C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If I understand you correctly, are you suggesting that in an embedded
system where there is no disk swapping, it makes sense to disable the
memory overcommit?

I'm testing a system with overcommit disabled and the overcommit ratio
set to 100%.  I am pleased with the fact that malloc() will actually
return NULL when we are about to exceed the commit limit.  If you look
at COMMITED_AS in /proc/meminfo, it looks to me like it reflects that
amount of memory currently allocated in the system.  I looked into
COMMIT_LIMIT and found that I can raise it to about 120% of physical or
so before the system is really out of memory.  When I load the system, I
see COMMITED_AS actually exceed the amount of physical RAM that I have.
Things appear to work.  My question now is how exactly is COMMITED_AS
calculated?


-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Tuesday, April 10, 2007 12:17 PM
To: Mouawad, Tony
Cc: Robert Hancock; linux-kernel@vger.kernel.org
Subject: Re: Help Understanding Linux memory management

On Tue, 10 Apr 2007 10:31:34 -0400
"Mouawad, Tony" <Tony.Mouawad@christiedigital.com> wrote:

> When vm.overcommit_memory = 2 and there appears to be about 2M of
memory
> readily available and about 12M of memory allocated to pagecache (this
> is info gathered from /proc/meminfo) , a call to malloc(5000000)
returns
> NULL.  I would have expected that somehow, the call to malloc(5000000)
> would request the memory in pagecache to be released for use by the
app.

That can only be done if the memory in the page cache is not being used.
In a system with swap it is possible for anonymous pages to be pushed to
disk, on a system without swap only unchanged disk mapped pages such as
executable progam pages (some of them anyway) can be thrown out if they
are still in use.

More importantly overcommit is address *space* not pages. It deals with
the theoretical worst cases and ensure that a page write won't cause an
out of memory situation. That means it is more pessimistic than the
usual
workload. It also by default allows lots of room for worst case kernel
behaviour that is appropriate to a real system with swap but not
embedded
so you may well want to tune that via the overcommit ratio proc
interface

Alan
