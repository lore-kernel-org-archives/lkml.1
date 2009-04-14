Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZDNO1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZDNO1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZDNO0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:26:46 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:35636 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756144AbZDNO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:26:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=izz9uJEMO0ksKwH/0zcNWMtZTvhZrg5d42cFWyYSy+8oPJpkCS2Gl9gtrgMOK40z4iYBf660Z5kvt8qkWUl0CfoxGhfutAMbwgtEfq20RLaJ9KXswUi4KXBNVpNtjaSbTuUMsDpvcvtyhKyTni9lbPYqTGbrkOA0KXDbz+wnqi4=  ;
X-YMail-OSG: nJKjqhkVM1nSngXiQrl054wOzhZbYAXMAXj1_9J4zTapc2gJShsBDm4nF2HZga7qpeqcF46K4EycLKVjOaA3noKFh_MbCMKMcnFrXqRB_oTou1PluOPcjznKDz2oH.CQJSKP.MkF4FxwvUibsEoJiCTcj1eWjL1QLzkqpyPy0wWcWvGhiqtfNEV1cS977qMcUbiqZ8dWbfvWu7K9Ka0s9LAuXKKan22U6qMs4QQ_Tf1XAudYX4lmqJlRnnWuZKG2_6zRBjbXvKY6Tt4mG_pohp.DqZNjb3Dffuz2J.u4gqD7Fu3J4bHs
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Date: Wed, 15 Apr 2009 00:26:34 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <2f11576a0904140639l426e137ewdc46296cdb377dd@mail.gmail.com> <20090414141209.GB31644@random.random>
In-Reply-To: <20090414141209.GB31644@random.random>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904150026.36142.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009 00:12:09 Andrea Arcangeli wrote:
> On Tue, Apr 14, 2009 at 10:39:54PM +0900, KOSAKI Motohiro wrote:
> > I guess you dislike get_user_page_fast() grab pte_lock too, right?
> 
> If get_user_page_fast is vetoed to run a set_bit on the already cache
> hot and exclusive struct page, I doubt taking a potentially cache
> cold, mm-wide or pmd-wide pte_lock is ok.

Yes, I'd *really* rather not. I actually implemented gup_fast in
response to problem reported with DB2 workload hitting the ptl
(and not the more obvious mmap_sem, although certainly they had
some gain from removing that cacheline as well).

gup_fast iirc is worth nearly 10% on a 4 socket x86 system with
DB2. That's the same order of magnitude as the speedups quoted
to justify the addition of hugepages, or O_DIRECT itself.

Andrea: I didn't veto that set_bit change of yours as such. I just
noted there could be more atomic operations. Actually I would
welcome more comparison between our two approaches, but they seem
to be stuck with Linus refusing (I think) to copy the page at
fork() time :(
