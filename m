Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYKGN7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYKGN7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYKGN7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:59:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:29671 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYKGN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:59:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:references:x-google-sender-auth;
        b=q1i3wGCsaFZULLcbgu3KtZYMpeRRy5Xh4O7q/2v94d4O39+nQrcAchiyd1XuFmwgDB
         ghXWBUUVdC4pvZx6quZoPeI/vJ6mIhauykpfnhAHA3TUTxOiHxjDiHiRRUwx6b0lftIq
         33n1s/wFxLDCFevgJVy8EBOuh9JxWIOQUAdpA=
Message-ID: <5ff4a1e50811070559s1cbc4420ie600e0004b5e7309@mail.gmail.com>
Date: Fri, 7 Nov 2008 13:59:39 +0000
From: "Matt Fleming" <mjf@netbsd.org>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: Allow section alignment
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <alpine.DEB.1.10.0811070825580.27455@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_28270_2851883.1226066379088"
References: <5ff4a1e50811070512v410e623ax60e8a65b169f800@mail.gmail.com>
	 <1226063896.2697.28.camel@twins>
	 <alpine.DEB.1.10.0811070825580.27455@gandalf.stny.rr.com>
X-Google-Sender-Auth: 7c7b761c9a26b51b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_28270_2851883.1226066379088
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/11/7 Steven Rostedt <rostedt@goodmis.org>:
>
> On Fri, 7 Nov 2008, Peter Zijlstra wrote:
>
>> On Fri, 2008-11-07 at 13:12 +0000, Matt Fleming wrote:
>> > Provide a means of aligning the __mcount_loc section.
>>
>> Not that I object to the patch, but this changelog needs work.
>>
>> Its wrong, it doesn't provide means, it plain does.
>> It doesn't tell us why.
>
> Also, please tell us what broke. Did you have a compiler that did
> not align it properly?  As long as the alignment is less than or equal to
> the word size, it is fine. If the alignment is larger than the word size,
> then there will be holes in the mcount_loc section and that will break
> ftrace. Heck, an alignment of 1 should work for everyone ;-) All the
> sections are packed together in an aligned space when it is pulled in by
> the linker. If that is not true, then the linker script needs to be fixed.
>

I've tried to explain the bug better in the attached patch. The issue
is not that there were gaps in __mcount_loc, rather that the addresses
in __mcount_loc were not aligned on a 4-byte boundary by the
assembler. Unaligned accesses are not supported by our architecture
and an alignment of 1-byte will likely lead to performance loss on
architectures that do support them.



>From 4161c8b2a1e5c93146fc6e9a638c018a14648c6b Mon Sep 17 00:00:00 2001
From: Matt Fleming <matthew.fleming@imgtec.com>
Date: Fri, 7 Nov 2008 13:26:25 +0000
Subject: [PATCH] ftrace: Align __mcount_loc sections

Align the __mcount_loc sections so that architectures with strict
alignment requirements need not worry about performing unaligned
accesses.

This fixes an issue where I was seeing unaligned accesses, which are not
supported on our architecture (the results of an unaligned access are
undefined).

Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
---
 scripts/recordmcount.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 6b9fe3e..2d0bfa1 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -134,6 +134,7 @@ my $section_regex;  # Find the start of a section
 my $function_regex;    # Find the name of a function
                        #    (return offset and func name)
 my $mcount_regex;      # Find the call site to mcount (return offset)
+my $alignment;         # The .align value to use for $mcount_section

 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -148,6 +149,7 @@ if ($arch eq "x86_64") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
+    $alignment = 8;

     # force flags for this arch
     $ld .= " -m elf_x86_64";
@@ -160,6 +162,7 @@ if ($arch eq "x86_64") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
     $type = ".long";
+    $alignment = 4;

     # force flags for this arch
     $ld .= " -m elf_i386";
@@ -288,6 +291,7 @@ sub update_funcs
            open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
            $opened = 1;
            print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+           print FILE "\t.align $alignment\n";
        }
        printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
     }
--
1.5.6.4

------=_Part_28270_2851883.1226066379088
Content-Type: text/x-diff;
 name=0001-ftrace-Align-__mcount_loc-sections.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fn8w88170
Content-Disposition: attachment;
 filename=0001-ftrace-Align-__mcount_loc-sections.patch

RnJvbSA0MTYxYzhiMmExZTVjOTMxNDZmYzZlOWE2MzhjMDE4YTE0NjQ4YzZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXR0IEZsZW1pbmcgPG1hdHRoZXcuZmxlbWluZ0BpbWd0ZWMu
Y29tPgpEYXRlOiBGcmksIDcgTm92IDIwMDggMTM6MjY6MjUgKzAwMDAKU3ViamVjdDogW1BBVENI
XSBmdHJhY2U6IEFsaWduIF9fbWNvdW50X2xvYyBzZWN0aW9ucwoKQWxpZ24gdGhlIF9fbWNvdW50
X2xvYyBzZWN0aW9ucyBzbyB0aGF0IGFyY2hpdGVjdHVyZXMgd2l0aCBzdHJpY3QKYWxpZ25tZW50
IHJlcXVpcmVtZW50cyBuZWVkIG5vdCB3b3JyeSBhYm91dCBwZXJmb3JtaW5nIHVuYWxpZ25lZAph
Y2Nlc3Nlcy4KClRoaXMgZml4ZXMgYW4gaXNzdWUgd2hlcmUgSSB3YXMgc2VlaW5nIHVuYWxpZ25l
ZCBhY2Nlc3Nlcywgd2hpY2ggYXJlIG5vdApzdXBwb3J0ZWQgb24gb3VyIGFyY2hpdGVjdHVyZSAo
dGhlIHJlc3VsdHMgb2YgYW4gdW5hbGlnbmVkIGFjY2VzcyBhcmUKdW5kZWZpbmVkKS4KClNpZ25l
ZC1vZmYtYnk6IE1hdHQgRmxlbWluZyA8bWF0dGhldy5mbGVtaW5nQGltZ3RlYy5jb20+Ci0tLQog
c2NyaXB0cy9yZWNvcmRtY291bnQucGwgfCAgICA0ICsrKysKIDEgZmlsZXMgY2hhbmdlZCwgNCBp
bnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3NjcmlwdHMvcmVjb3Jk
bWNvdW50LnBsIGIvc2NyaXB0cy9yZWNvcmRtY291bnQucGwKaW5kZXggNmI5ZmUzZS4uMmQwYmZh
MSAxMDA3NTUKLS0tIGEvc2NyaXB0cy9yZWNvcmRtY291bnQucGwKKysrIGIvc2NyaXB0cy9yZWNv
cmRtY291bnQucGwKQEAgLTEzNCw2ICsxMzQsNyBAQCBteSAkc2VjdGlvbl9yZWdleDsJIyBGaW5k
IHRoZSBzdGFydCBvZiBhIHNlY3Rpb24KIG15ICRmdW5jdGlvbl9yZWdleDsJIyBGaW5kIHRoZSBu
YW1lIG9mIGEgZnVuY3Rpb24KIAkJCSMgICAgKHJldHVybiBvZmZzZXQgYW5kIGZ1bmMgbmFtZSkK
IG15ICRtY291bnRfcmVnZXg7CSMgRmluZCB0aGUgY2FsbCBzaXRlIHRvIG1jb3VudCAocmV0dXJu
IG9mZnNldCkKK215ICRhbGlnbm1lbnQ7CQkjIFRoZSAuYWxpZ24gdmFsdWUgdG8gdXNlIGZvciAk
bWNvdW50X3NlY3Rpb24KIAogaWYgKCRhcmNoIGVxICJ4ODYiKSB7CiAgICAgaWYgKCRiaXRzID09
IDY0KSB7CkBAIC0xNDgsNiArMTQ5LDcgQEAgaWYgKCRhcmNoIGVxICJ4ODZfNjQiKSB7CiAgICAg
JGZ1bmN0aW9uX3JlZ2V4ID0gIl4oWzAtOWEtZkEtRl0rKVxccys8KC4qPyk+OiI7CiAgICAgJG1j
b3VudF9yZWdleCA9ICJeXFxzKihbMC05YS1mQS1GXSspOi4qXFxzbWNvdW50KFsrLV0weFswLTlh
LXpBLVpdKyk/XCQiOwogICAgICR0eXBlID0gIi5xdWFkIjsKKyAgICAkYWxpZ25tZW50ID0gODsK
IAogICAgICMgZm9yY2UgZmxhZ3MgZm9yIHRoaXMgYXJjaAogICAgICRsZCAuPSAiIC1tIGVsZl94
ODZfNjQiOwpAQCAtMTYwLDYgKzE2Miw3IEBAIGlmICgkYXJjaCBlcSAieDg2XzY0IikgewogICAg
ICRmdW5jdGlvbl9yZWdleCA9ICJeKFswLTlhLWZBLUZdKylcXHMrPCguKj8pPjoiOwogICAgICRt
Y291bnRfcmVnZXggPSAiXlxccyooWzAtOWEtZkEtRl0rKTouKlxcc21jb3VudFwkIjsKICAgICAk
dHlwZSA9ICIubG9uZyI7CisgICAgJGFsaWdubWVudCA9IDQ7CiAKICAgICAjIGZvcmNlIGZsYWdz
IGZvciB0aGlzIGFyY2gKICAgICAkbGQgLj0gIiAtbSBlbGZfaTM4NiI7CkBAIC0yODgsNiArMjkx
LDcgQEAgc3ViIHVwZGF0ZV9mdW5jcwogCSAgICBvcGVuKEZJTEUsICI+JG1jb3VudF9zIikgfHwg
ZGllICJjYW4ndCBjcmVhdGUgJG1jb3VudF9zXG4iOwogCSAgICAkb3BlbmVkID0gMTsKIAkgICAg
cHJpbnQgRklMRSAiXHQuc2VjdGlvbiAkbWNvdW50X3NlY3Rpb24sXCJhXCIsXEBwcm9nYml0c1xu
IjsKKwkgICAgcHJpbnQgRklMRSAiXHQuYWxpZ24gJGFsaWdubWVudFxuIjsKIAl9CiAJcHJpbnRm
IEZJTEUgIlx0JXMgJXMgKyAlZFxuIiwgJHR5cGUsICRyZWZfZnVuYywgJG9mZnNldHNbJGldIC0g
JG9mZnNldDsKICAgICB9Ci0tIAoxLjUuNi40Cgo=
------=_Part_28270_2851883.1226066379088--
