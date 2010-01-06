Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304Ab0AFHtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0AFHtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485Ab0AFHtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:49:19 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:52326 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0AFHtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:49:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fqGaUwb5wOhz+G5rlg2qwVcgf1dX1ko1XgIIx+Ozhka8ayh9vV2bzD8BonWcR51cju
         D0wfvKiv9PMO+3nav6HpeAjkQ5vQakncxFztonN2WDYlqBKBX6ujmebfrAoa++eUnPaa
         9+Kf4yUPIniWXAEdO6Sp9XtkMqkMNnlignpCY=
MIME-Version: 1.0
In-Reply-To: <20100106160614.ff756f82.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100104182429.833180340@chello.nl>
	 <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
	 <20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001051718100.3630@localhost.localdomain>
	 <20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001051917000.3630@localhost.localdomain>
	 <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001052007090.3630@localhost.localdomain>
	 <20100106160614.ff756f82.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 6 Jan 2010 16:49:17 +0900
Message-ID: <28c262361001052349q1605a312obf81ce9445ce714f@mail.gmail.com>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o067nw16015216

At last your patient try makes the problem solvealthough it's from not your patch series.
Thanks for very patient try and testing until now, Kame. :)I learned lot of things from this thread.
Thanks, all.
On Wed, Jan 6, 2010 at 4:06 PM, KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:> On Tue, 5 Jan 2010 20:20:56 -0800 (PST)> Linus Torvalds <torvalds@linux-foundation.org> wrote:>>>>>>> On Wed, 6 Jan 2010, KAMEZAWA Hiroyuki wrote:>> > >>> > > Of course, your other load with MADV_DONTNEED seems to be horrible, and>> > > has some nasty spinlock issues, but that looks like a separate deal (I>> > > assume that load is just very hard on the pgtable lock).>> >>> > It's zone->lock, I guess. My test program avoids pgtable lock problem.>>>> Yeah, I should have looked more at your callchain. That's nasty. Much>> worse than the per-mm lock. I thought the page buffering would avoid the>> zone lock becoming a huge problem, but clearly not in this case.>>> For my mental peace, I rewrote test program as>>  while () {>        touch memory>        barrier>        madvice DONTNEED all range by cpu 0>        barrier>  }> And serialize madivce().>> Then, zone->lock disappears and I don't see big difference with XADD rwsem and> my tricky patch. I think I got reasonable result and fixing rwsem is the sane way.>> next target will be clear_page()? hehe.> What catches my eyes is cost of memcg... (>_<>> Thank you all,> -Kame> ==> [XADD rwsem]> [root@bluextal memory]#  /root/bin/perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault-all 8>>  Performance counter stats for './multi-fault-all 8' (5 runs):>>       33029186  page-faults                ( +-   0.146% )>      348698659  cache-misses               ( +-   0.149% )>>   60.002876268  seconds time elapsed   ( +-   0.001% )>> # Samples: 815596419603> #> # Overhead          Command             Shared Object  Symbol> # ........  ...............  ........................  ......> #>    41.51%  multi-fault-all  [kernel]                  [k] clear_page_c>     9.08%  multi-fault-all  [kernel]                  [k] down_read_trylock>     6.23%  multi-fault-all  [kernel]                  [k] up_read>     6.17%  multi-fault-all  [kernel]                  [k] __mem_cgroup_try_charg>     4.76%  multi-fault-all  [kernel]                  [k] handle_mm_fault>     3.77%  multi-fault-all  [kernel]                  [k] __mem_cgroup_commit_ch>     3.62%  multi-fault-all  [kernel]                  [k] __rmqueue>     2.30%  multi-fault-all  [kernel]                  [k] _raw_spin_lock>     2.30%  multi-fault-all  [kernel]                  [k] page_fault>     2.12%  multi-fault-all  [kernel]                  [k] mem_cgroup_charge_comm>     2.05%  multi-fault-all  [kernel]                  [k] bad_range>     1.78%  multi-fault-all  [kernel]                  [k] _raw_spin_lock_irq>     1.53%  multi-fault-all  [kernel]                  [k] lookup_page_cgroup>     1.44%  multi-fault-all  [kernel]                  [k] __mem_cgroup_uncharge_>     1.41%  multi-fault-all  ./multi-fault-all         [.] worker>     1.30%  multi-fault-all  [kernel]                  [k] get_page_from_freelist>     1.06%  multi-fault-all  [kernel]                  [k] page_remove_rmap>>>> [async page fault]> [root@bluextal memory]#  /root/bin/perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault-all 8>>  Performance counter stats for './multi-fault-all 8' (5 runs):>>       33345089  page-faults                ( +-   0.555% )>      357660074  cache-misses               ( +-   1.438% )>>   60.003711279  seconds time elapsed   ( +-   0.002% )>>>    40.94%  multi-fault-all  [kernel]                  [k] clear_page_c>     6.96%  multi-fault-all  [kernel]                  [k] vma_put>     6.82%  multi-fault-all  [kernel]                  [k] page_add_new_anon_rmap>     5.86%  multi-fault-all  [kernel]                  [k] __mem_cgroup_try_charg>     4.40%  multi-fault-all  [kernel]                  [k] __rmqueue>     4.14%  multi-fault-all  [kernel]                  [k] find_vma_speculative>     3.97%  multi-fault-all  [kernel]                  [k] handle_mm_fault>     3.52%  multi-fault-all  [kernel]                  [k] _raw_spin_lock>     3.46%  multi-fault-all  [kernel]                  [k] __mem_cgroup_commit_ch>     2.23%  multi-fault-all  [kernel]                  [k] bad_range>     2.16%  multi-fault-all  [kernel]                  [k] mem_cgroup_charge_comm>     1.96%  multi-fault-all  [kernel]                  [k] _raw_spin_lock_irq>     1.75%  multi-fault-all  [kernel]                  [k] mem_cgroup_add_lru_lis>     1.73%  multi-fault-all  [kernel]                  [k] page_fault>


-- Kind regards,Minchan Kim���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
