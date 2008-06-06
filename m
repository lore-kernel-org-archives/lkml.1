Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYFFOgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYFFOgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbYFFOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:36:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:44651 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbYFFOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=UenFqguzC4u4/c/bo0umf8MeIKPhDHnLe5xrq52I2h5mkL47W6qOHt1/f1+gUl4wPB
         kQ+qRLAk2d/ExTH7FM+pHSxcnfNYkVTZerXBPUwrxWTh1V9xXL1suCL51kAWKzKPFDYo
         Dat9BUPuvWqfl4eYHVlCuh7prlH58XbqYtsr8=
Message-ID: <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com>
Date: Fri, 6 Jun 2008 16:36:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Travis" <travis@sgi.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux-next: Tree for June 5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <484947A9.5050804@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2738_20405039.1212762964578"
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	 <20080606002957.6329a0ec.akpm@linux-foundation.org>
	 <20080606024811.70db9ab2.akpm@linux-foundation.org>
	 <20080606035413.37f340ef.akpm@linux-foundation.org>
	 <20080606115759.GA29321@elte.hu>
	 <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com>
	 <48493CBD.1000202@sgi.com>
	 <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com>
	 <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com>
	 <484947A9.5050804@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2738_20405039.1212762964578
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Jun 6, 2008 at 4:20 PM, Mike Travis <travis@sgi.com> wrote:
> Vegard Nossum wrote:
>> On Fri, Jun 6, 2008 at 3:50 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> On Fri, Jun 6, 2008 at 3:33 PM, Mike Travis <travis@sgi.com> wrote:
>>>> Vegard Nossum wrote:
>>>>> I reproced it with gc 4.1.2. I think the error is somewhere in kernel/sched.c.
>>>>>
>>>>> static int __build_sched_domains(const cpumask_t *cpu_map,
>>>>>                                  struct sched_domain_attr *attr)
>>>>> {
>>>>> ...
>>>>>         for (i = 0; i < MAX_NUMNODES; i++) {
>>>>> ...
>>>>>                 sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
>>>>> ...
>>>>>
>>>>> This code is calling into the allocator with a spurious value of i,
>>>>> which causes SLAB to use an index (of 4 in my case) that is out of
>>>>> bounds for its nodelist array (at least it hasn't been initialized).
>>>>>

...

>> The error is of course that the node masks for nodes > nr_node_ids are
>> not valid. While this function ignores that:
>>
>> cpumask_t *_node_to_cpumask_ptr(int node)
>> {
>>         if (node_to_cpumask_map == NULL) {
>>                 printk(KERN_WARNING
>>                         "_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
>>                         node);
>>                 dump_stack();
>>                 return &cpu_online_map;
>>         }
>>         return &node_to_cpumask_map[node];
>> }
>> EXPORT_SYMBOL(_node_to_cpumask_ptr);
>>
>> Notice the return statement. It needs to check if node < nr_node_ids.
>>

...

>
> Thanks, yes I had that some after thought.  It should check the node
> index if CONFIG_DEBUG_PER_CPU_MAPS is enabled.  One gotcha is that
> nr_node_ids is intialized to MAX_NUMNODES until setup_node_to_cpumask_map()
> sets it to the correct value.  So uses before that should be caught by
> the earlier check.

I think it should always check the node index. The code in
kernel/sched.c (see above) calls node_to_cpumask(i) on nodes 0 < i <
MAX_NUMNODES and it WILL use invalid pointers. Or should
kernel/sched.c be changed to use nr_node_ids instead of MAX_NUMNODES?
I believe there are more places that do this than just sched.c.

I have attached two patches. The sched one fixes Andrew's boot
problem. The x86 one is untested, but I believe it is better to BUG
than silently corrupt some arbitrary memory. (Then the callers can be
found easily and fixed at least.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_2738_20405039.1212762964578
Content-Type: text/x-patch;
 name=0001-sched-don-t-call-node_to_cpumask-on-nodes-nr_no.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh4vlwy60
Content-Disposition: attachment;
 filename=0001-sched-don-t-call-node_to_cpumask-on-nodes-nr_no.patch

RnJvbSAyMTZkY2JkZWM3OWQ3NmM0ZDczOGYyYzBhYWQ0MTA2MWY4MDU2NGU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWZWdhcmQgTm9zc3VtIDx2ZWdhcmRub0BiZW4uaWZpLnVpby5u
bz4KRGF0ZTogRnJpLCA2IEp1biAyMDA4IDE2OjMxOjE5ICswMjAwClN1YmplY3Q6IFtQQVRDSF0g
c2NoZWQ6IGRvbid0IGNhbGwgbm9kZV90b19jcHVtYXNrKCkgb24gbm9kZXMgPiBucl9ub2RlX2lk
cwoKU2lnbmVkLW9mZi1ieTogVmVnYXJkIE5vc3N1bSA8dmVnYXJkbm9AYmVuLmlmaS51aW8ubm8+
Ci0tLQoga2VybmVsL3NjaGVkLmMgfCAgIDEwICsrKysrLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwg
NSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hl
ZC5jIGIva2VybmVsL3NjaGVkLmMKaW5kZXggZmM5YmE5MC4uOGFiOWNkNiAxMDA2NDQKLS0tIGEv
a2VybmVsL3NjaGVkLmMKKysrIGIva2VybmVsL3NjaGVkLmMKQEAgLTY3NzAsNyArNjc3MCw3IEBA
IHN0YXRpYyB2b2lkIGZyZWVfc2NoZWRfZ3JvdXBzKGNvbnN0IGNwdW1hc2tfdCAqY3B1X21hcCwg
Y3B1bWFza190ICpub2RlbWFzaykKIAkJaWYgKCFzY2hlZF9ncm91cF9ub2RlcykKIAkJCWNvbnRp
bnVlOwogCi0JCWZvciAoaSA9IDA7IGkgPCBNQVhfTlVNTk9ERVM7IGkrKykgeworCQlmb3IgKGkg
PSAwOyBpIDwgbnJfbm9kZV9pZHM7IGkrKykgewogCQkJc3RydWN0IHNjaGVkX2dyb3VwICpvbGRz
ZywgKnNnID0gc2NoZWRfZ3JvdXBfbm9kZXNbaV07CiAKIAkJCSpub2RlbWFzayA9IG5vZGVfdG9f
Y3B1bWFzayhpKTsKQEAgLTcwOTcsNyArNzA5Nyw3IEBAIHN0YXRpYyBpbnQgX19idWlsZF9zY2hl
ZF9kb21haW5zKGNvbnN0IGNwdW1hc2tfdCAqY3B1X21hcCwKICNlbmRpZgogCiAJLyogU2V0IHVw
IHBoeXNpY2FsIGdyb3VwcyAqLwotCWZvciAoaSA9IDA7IGkgPCBNQVhfTlVNTk9ERVM7IGkrKykg
eworCWZvciAoaSA9IDA7IGkgPCBucl9ub2RlX2lkczsgaSsrKSB7CiAJCVNDSEVEX0NQVU1BU0tf
VkFSKG5vZGVtYXNrLCBhbGxtYXNrcyk7CiAJCVNDSEVEX0NQVU1BU0tfVkFSKHNlbmRfY292ZXJl
ZCwgYWxsbWFza3MpOwogCkBAIC03MTIxLDcgKzcxMjEsNyBAQCBzdGF0aWMgaW50IF9fYnVpbGRf
c2NoZWRfZG9tYWlucyhjb25zdCBjcHVtYXNrX3QgKmNwdV9tYXAsCiAJCQkJCXNlbmRfY292ZXJl
ZCwgdG1wbWFzayk7CiAJfQogCi0JZm9yIChpID0gMDsgaSA8IE1BWF9OVU1OT0RFUzsgaSsrKSB7
CisJZm9yIChpID0gMDsgaSA8IG5yX25vZGVfaWRzOyBpKyspIHsKIAkJLyogU2V0IHVwIG5vZGUg
Z3JvdXBzICovCiAJCXN0cnVjdCBzY2hlZF9ncm91cCAqc2csICpwcmV2OwogCQlTQ0hFRF9DUFVN
QVNLX1ZBUihub2RlbWFzaywgYWxsbWFza3MpOwpAQCAtNzE2MCw5ICs3MTYwLDkgQEAgc3RhdGlj
IGludCBfX2J1aWxkX3NjaGVkX2RvbWFpbnMoY29uc3QgY3B1bWFza190ICpjcHVfbWFwLAogCQlj
cHVzX29yKCpjb3ZlcmVkLCAqY292ZXJlZCwgKm5vZGVtYXNrKTsKIAkJcHJldiA9IHNnOwogCi0J
CWZvciAoaiA9IDA7IGogPCBNQVhfTlVNTk9ERVM7IGorKykgeworCQlmb3IgKGogPSAwOyBqIDwg
bnJfbm9kZV9pZHM7IGorKykgewogCQkJU0NIRURfQ1BVTUFTS19WQVIobm90Y292ZXJlZCwgYWxs
bWFza3MpOwotCQkJaW50IG4gPSAoaSArIGopICUgTUFYX05VTU5PREVTOworCQkJaW50IG4gPSAo
aSArIGopICUgbnJfbm9kZV9pZHM7CiAJCQlub2RlX3RvX2NwdW1hc2tfcHRyKHBub2RlbWFzaywg
bik7CiAKIAkJCWNwdXNfY29tcGxlbWVudCgqbm90Y292ZXJlZCwgKmNvdmVyZWQpOwotLSAKMS41
LjMuMQoK
------=_Part_2738_20405039.1212762964578
Content-Type: text/x-patch;
 name=0001-x86-don-t-return-invalid-pointers-from-node_to_cpum.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh4vokq51
Content-Disposition: attachment;
 filename=0001-x86-don-t-return-invalid-pointers-from-node_to_cpum.patch

RnJvbSBiOTkzZTczNDliOTU0NTU1NzE1YzJhZGFkNjkwNzExNDY1YmJkNjBjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWZWdhcmQgTm9zc3VtIDx2ZWdhcmQubm9zc3VtQGdtYWlsLmNv
bT4KRGF0ZTogRnJpLCA2IEp1biAyMDA4IDE2OjMzOjI1ICswMjAwClN1YmplY3Q6IFtQQVRDSF0g
eDg2OiBkb24ndCByZXR1cm4gaW52YWxpZCBwb2ludGVycyBmcm9tIG5vZGVfdG9fY3B1bWFzaygp
CgpTaWduZWQtb2ZmLWJ5OiBWZWdhcmQgTm9zc3VtIDx2ZWdhcmQubm9zc3VtQGdtYWlsLmNvbT4K
LS0tCiBhcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYyB8ICAgIDIgKysKIDEgZmlsZXMgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tl
cm5lbC9zZXR1cC5jIGIvYXJjaC94ODYva2VybmVsL3NldHVwLmMKaW5kZXggOGVjZjdiNC4uODQx
MWM1NSAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL3NldHVwLmMKKysrIGIvYXJjaC94ODYv
a2VybmVsL3NldHVwLmMKQEAgLTM4NSw2ICszODUsNyBAQCBjcHVtYXNrX3QgKl9ub2RlX3RvX2Nw
dW1hc2tfcHRyKGludCBub2RlKQogCQlkdW1wX3N0YWNrKCk7CiAJCXJldHVybiAmY3B1X29ubGlu
ZV9tYXA7CiAJfQorCUJVR19PTihub2RlID49IG5yX25vZGVfaWRzKTsKIAlyZXR1cm4gJm5vZGVf
dG9fY3B1bWFza19tYXBbbm9kZV07CiB9CiBFWFBPUlRfU1lNQk9MKF9ub2RlX3RvX2NwdW1hc2tf
cHRyKTsKQEAgLTQwMCw2ICs0MDEsNyBAQCBjcHVtYXNrX3Qgbm9kZV90b19jcHVtYXNrKGludCBu
b2RlKQogCQlkdW1wX3N0YWNrKCk7CiAJCXJldHVybiBjcHVfb25saW5lX21hcDsKIAl9CisJQlVH
X09OKG5vZGUgPj0gbnJfbm9kZV9pZHMpOwogCXJldHVybiBub2RlX3RvX2NwdW1hc2tfbWFwW25v
ZGVdOwogfQogRVhQT1JUX1NZTUJPTChub2RlX3RvX2NwdW1hc2spOwotLSAKMS41LjQuMQoK
------=_Part_2738_20405039.1212762964578--
