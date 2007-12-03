Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbXLCWrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbXLCWrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXLCWrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:47:02 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXLCWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:46:59 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Out of tree module using LSM
To: Jon Masters <jonathan@jonmasters.org>, Ray Lee <ray-lk@madrabbit.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Reply-To: 7eggert@gmx.de
Date: Mon, 03 Dec 2007 23:45:42 +0100
References: <9uzZr-6iz-19@gated-at.bofh.it> <9uUrm-5w3-27@gated-at.bofh.it> <9uVGz-7uQ-19@gated-at.bofh.it> <9uWCC-xI-13@gated-at.bofh.it> <9uWMp-Ix-13@gated-at.bofh.it> <9uX5A-1rs-1@gated-at.bofh.it> <9uXyK-24f-23@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1IzK2o-00045u-Ha@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/NFaa60vD02ofzVq5VCZdUelH8HK2MZtmWdJF
 c1HYlXXrxd1c3OWDN7HgBli6sB+LRJecdGd4bwJuj6bVK4VoAz
 8MHYnGQ1JayKP7eImd2tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters <jonathan@jonmasters.org> wrote:
> On Thu, 2007-11-29 at 11:11 -0800, Ray Lee wrote:
>> On Nov 29, 2007 10:56 AM, Jon Masters <jonathan@jonmasters.org> wrote:
>> > On Thu, 2007-11-29 at 10:40 -0800, Ray Lee wrote:
>> > > On Nov 29, 2007 9:36 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> > > > > closed. But more importantly further access to it can be blocked
>> > > > > until appropriate actions are taken which also applies with your
>> > > > > example, no? Is
>> > > >
>> > > > That bit is hard- very hard.

>> To lift Alan's example, a naive first implementation
>> would be to create a suffix tree of all of ESR's works, then scan each
>> page on fault to see if there are any partial matches in the tree.
> 
> Ah, but I could write a sequence of pages that on their own looked
> garbage, but in reality, when executed would print out a copy of the
> Jargon File in all its glory. And if you still think you could look for
> patterns, how about executable code that self-modifies in random ways
> but when executed as a whole actually has the functionality of fetchmail
> embedded within it? How would you guard against that?

You can't scan all possible code for malware:
Take a random piece of code, possibly halting. Replace all halting conditions
using a piece of malware. Scan it. If it were possible to detect the malware
without false positives, you'd have solved the halting problem.

In practice, this does not hinder virus scanners from preventing most damage.
Therefore I think it's OK to have one.


If I had to design a virus scanner interface, I'd e.g. create a library*
providing an {open|mmap}_and_scan() function that would give me a clean
copy/really-private mapping of a scanned file, and a scan_{blob,file}()
function that would scan a block of memory/a file. Then, it's up to the
application to ensure that it uses that library. As a result, you could
e.g. run "less eicar.sh", but you could not run "bash eicar.sh"**, and an
application receiving a strangely encoded piece of malware into it's
memory has a chance of avoiding an infection without writing it to a file.
Maybe gpg < eicar.gpg.sh|sh will unintendedly work, but I don't think
scanning pipes would be easy anyway. OTOH, maybe the library would make
it feasible at all, provided the malicious code is not located way before
the signature.

Off cause I'd need to do something about binaries. At first glance, this
does not seem too bad, since there is a way to run ld*.so. I'd just use it
to enforce a preloader for static binaries, too. (I'm glad I can leave the
implementation details to somebody else.-)


*  Without having a virus scanner installed, this library will just NOOP
   by default.

** Bonus: I can unzip open_office_file; rm macros; zip open_office_file.
   OTOH, the scanner should provide a cleaner for those simple cases.

