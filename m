Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYBEHLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYBEHLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYBEHK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:10:56 -0500
Received: from [212.12.190.68] ([212.12.190.68]:50264 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752925AbYBEHKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:10:55 -0500
From: Al Boldi <a1426z@gawab.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Tue, 5 Feb 2008 10:07:44 +0300
User-Agent: KMail/1.5
Cc: Chris Mason <chris.mason@oracle.com>, Andreas Dilger <adilger@sun.com>,
       Chris Snook <csnook@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <200802020026.00998.a1426z@gawab.com> <20080204175415.GH3426@duck.suse.cz>
In-Reply-To: <20080204175415.GH3426@duck.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802051007.44139.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Sat 02-02-08 00:26:00, Al Boldi wrote:
> > Chris Mason wrote:
> > > Al, could you please compare the write throughput from vmstat for the
> > > data=ordered vs data=writeback runs?  I would guess the data=ordered
> > > one has a lower overall write throughput.
> >
> > That's what I would have guessed, but it's actually going up 4x fold for
> > mysql from 559mb to 2135mb, while the db-size ends up at 549mb.
>
>   So you say we write 4-times as much data in ordered mode as in writeback
> mode. Hmm, probably possible because we force all the dirty data to disk
> when committing a transation in ordered mode (and don't do this in
> writeback mode). So if the workload repeatedly dirties the whole DB, we
> are going to write the whole DB several times in ordered mode but in
> writeback mode we just keep the data in memory all the time. But this is
> what you ask for if you mount in ordered mode so I wouldn't consider it a
> bug.

Ok, maybe not a bug, but a bit inefficient.  Check out this workload:

sync;

while :; do
  dd < /dev/full > /mnt/sda2/x.dmp bs=1M count=20
  rm -f /mnt/sda2/x.dmp
  usleep 10000
done

vmstat 1 ( with mount /dev/sda2 /mnt/sda2 -o data=writeback) << note io-bo >>

procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 2  0      0 293008   5232  57436    0    0     0     0   18   206  4 80 16  0
 1  0      0 282840   5232  67620    0    0     0     0   18   238  3 81 16  0
 1  0      0 297032   5244  53364    0    0     0   152   21   211  4 79 17  0
 1  0      0 285236   5244  65224    0    0     0     0   18   232  4 80 16  0
 1  0      0 299464   5244  50880    0    0     0     0   18   222  4 80 16  0
 1  0      0 290156   5244  60176    0    0     0     0   18   236  3 80 17  0
 0  0      0 302124   5256  47788    0    0     0   152   21   213  4 80 16  0
 1  0      0 292180   5256  58248    0    0     0     0   18   239  3 81 16  0
 1  0      0 287452   5256  62444    0    0     0     0   18   202  3 80 17  0
 1  0      0 293016   5256  57392    0    0     0     0   18   250  4 80 16  0
 0  0      0 302052   5256  47788    0    0     0     0   19   194  3 81 16  0
 1  0      0 297536   5268  52928    0    0     0   152   20   233  4 79 17  0
 1  0      0 286468   5268  63872    0    0     0     0   18   212  3 81 16  0
 1  0      0 301572   5268  48812    0    0     0     0   18   267  4 79 17  0
 1  0      0 292636   5268  57776    0    0     0     0   18   208  4 80 16  0
 1  0      0 302124   5280  47788    0    0     0   152   21   237  4 80 16  0
 1  0      0 291436   5280  58976    0    0     0     0   18   205  3 81 16  0
 1  0      0 302068   5280  47788    0    0     0     0   18   234  3 81 16  0
 1  0      0 293008   5280  57388    0    0     0     0   18   221  4 79 17  0
 1  0      0 297288   5292  52532    0    0     0   156   22   233  2 81 16  1
 1  0      0 294676   5292  55724    0    0     0     0   19   199  3 81 16  0


vmstat 1 (with mount /dev/sda2 /mnt/sda2 -o data=ordered)

procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 2  0      0 291052   5156  59016    0    0     0     0   19   223  3 82 15  0
 1  0      0 291408   5156  58704    0    0     0     0   18   218  3 81 16  0
 1  0      0 291888   5156  58276    0    0     0    20   23   229  3 80 17  0
 1  0      0 300764   5168  49472    0    0     0 12864   91   235  3 69 13 15
 1  0      0 300740   5168  49456    0    0     0     0   19   215  3 80 17  0
 1  0      0 301088   5168  49044    0    0     0     0   18   241  4 80 16  0
 1  0      0 298220   5168  51872    0    0     0     0   18   225  3 81 16  0
 0  1      0 289168   5168  60752    0    0     0 12712   45   237  3 77 15  5
 1  0      0 300260   5180  49852    0    0     0   152   68   211  4 72 15  9
 1  0      0 298616   5180  51460    0    0     0     0   18   237  3 81 16  0
 1  0      0 296988   5180  53092    0    0     0     0   18   223  3 81 16  0
 1  0      0 296608   5180  53480    0    0     0     0   18   223  3 81 16  0
 0  0      0 301640   5192  48036    0    0     0 12868   93   206  4 67 13 16
 0  0      0 301624   5192  48036    0    0     0     0   21   218  3 81 16  0
 0  0      0 301600   5192  48036    0    0     0     0   18   212  3 81 16  0
 0  0      0 301584   5192  48036    0    0     0     0   18   209  4 80 16  0
 0  0      0 301568   5192  48036    0    0     0     0   18   208  3 81 16  0
 1  0      0 285520   5204  64548    0    0     0 12864   95   216  3 69 13 15
 2  0      0 285124   5204  64924    0    0     0     0   18   222  4 80 16  0
 1  0      0 283612   5204  66392    0    0     0     0   18   231  3 81 16  0
 1  0      0 284216   5204  65736    0    0     0     0   18   218  4 80 16  0
 0  1      0 289160   5204  60752    0    0     0 12712   56   213  3 74 15  8
 1  0      0 285884   5216  64128    0    0     0   152   54   209  4 75 15  6
 1  0      0 287472   5216  62572    0    0     0     0   18   223  3 81 16  0

Do you think these 12mb redundant writeouts could be buffered?

(Note: you may need to adjust dd count and usleep to see the same effect)

> I still don't like your hack with per-process journal mode setting
> but we could easily do per-file journal mode setting (we already have a
> flag to do data journaling for a file) and that would help at least your
> DB workload...

Well, that depends on what kind of db you use.  mysql creates db's as a dir,
and then manages the tables and indexes as files inside that dir.  So I don't
think this flag would be feasible for that use-case.  Much easier to just say:

  echo 1 > /proc/`pidof mysqld`/soft-sync

But the per-file flag could definitely help the file-mmap case, and as such
could be a great additional feature in combination to this RFC.


Thanks!

--
Al

