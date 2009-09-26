Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZIZDJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZIZDJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 23:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIZDJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 23:09:41 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:55074 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZIZDJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 23:09:40 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2009 23:09:40 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Zhc1QcmEbh040MCjYjr32FaT678ZZ/oZHvxsgJUUyz6Vy+CGhzeDrYJxDv2QjUcl/s
         bs+ifLfKHBuiXGVApKAq++64tzg0qBPbdvy8J1BEI+og93Eok6opvYdkm2ss6EfZLjZT
         quMlGLs55J+fd9itQUn8VqL13D6IuGUmBLx0w=
MIME-Version: 1.0
In-Reply-To: <20090804141623.GD7746@elte.hu>
References: <4A6E0825.3020604@windriver.com> <1248725893.6987.2055.camel@twins>
	 <4A6F139C.6070806@windriver.com> <20090804141623.GD7746@elte.hu>
Date: Sat, 26 Sep 2009 11:01:37 +0800
Message-ID: <2674af740909252001ocfcc9cev80d73924289ba52c@mail.gmail.com>
Subject: Re: [PATCH] softlockup: fix problem with long kernel pauses from kgdb
From: Yong Zhang <yong.zhang0@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>
Content-Type: multipart/mixed; boundary=001636e1f9387770a00474724875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e1f9387770a00474724875
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2009 at 10:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jason Wessel <jason.wessel@windriver.com> wrote:
>
>> Peter Zijlstra wrote:
>> > On Mon, 2009-07-27 at 15:03 -0500, Jason Wessel wrote:
>> >> The fix is to simply invoke sched_clock_tick() to update "cpu sched
>> >> clock" on exit from kgdb_handle_exception.
>> >
>> > Is that a regular IRQ context, or is that NMI context?
>> >
>> >> Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
>> >> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> >> Cc: Ingo Molnar <mingo@elte.hu>
>> >> Cc: peterz@infradead.org
>> >> ---
>> >> =C2=A0kernel/softlockup.c | =C2=A0 =C2=A03 +++
>> >> =C2=A01 file changed, 3 insertions(+)
>> >>
>> >> --- a/kernel/softlockup.c
>> >> +++ b/kernel/softlockup.c
>> >> @@ -118,6 +118,9 @@ void softlockup_tick(void)
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> >>
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (touch_timestamp =3D=3D 0) {
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* If the time sta=
mp was touched externally make sure the
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* scheduler =
tick is up to date as well */
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sched_clock_tick()=
;
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __touch_softl=
ockup_watchdog();
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> >>
>> >
>> > Aside from the funny comment style (please fix) the fix does look
>> > sensible.
>>
>> It turns out that further testing of this patch shows a regression in
>> the ability to detect certain lockups. =C2=A0It is a direct result of th=
e
>> way the scheduling code makes use of the touch_softlockup_watchdog().
>> With the above proposed patch the tick was getting updated after a
>> resume, but was also getting updated with the run_timers(), and if
>> that happened before the softlockup tick, no softlockup would get
>> reported (note that I was using some test code to induce softlockups).
>>
>> The patch below is a bit more invasive but solves the problem by
>> allowing kgdb to request that the sched cpu clock is updated only when
>> returning from a state where we know we need to force the update.
>>
>> Would this change be an acceptable solution to allow kgdb to
>> peacefully exist with the softlockup code?
>>
>> Thanks,
>> Jason.
>>
>>
>> -----
>> From: Jason Wessel <jason.wessel@windriver.com>
>> Subject: [PATCH] softlockup: add sched_clock_tick() to avoid kernel warn=
ing on kgdb resume
>>
>> When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set sched_clock() gets the
>> time from hardware, such as from TSC. =C2=A0In this configuration kgdb w=
ill
>> report a softlock warning messages on resuming or detaching from a
>> debug session.
>>
>> Sequence of events in the problem case:
>>
>> 1) "cpu sched clock" and "hardware time" are at 100 sec prior
>> =C2=A0 =C2=A0to a call to kgdb_handle_exception()
>>
>> 2) Debugger waits in kgdb_handle_exception() for 80 sec and on exit
>> =C2=A0 =C2=A0the following is called ... =C2=A0touch_softlockup_watchdog=
() -->
>> =C2=A0 =C2=A0__raw_get_cpu_var(touch_timestamp) =3D 0;
>>
>> 3) "cpu sched clock" =3D 100s (it was not updated, because the interrupt
>> =C2=A0 =C2=A0was disabled in kgdb) but the "hardware time" =3D 180 sec
>>
>> 4) The first timer interrupt after resuming from kgdb_handle_exception
>> =C2=A0 =C2=A0updates the watchdog from the "cpu sched clock"
>>
>> update_process_times() { ... =C2=A0run_local_timers() --> softlockup_tic=
k()
>> --> check (touch_timestamp =3D=3D 0) (it is "YES" here, we have set
>> "touch_timestamp =3D 0" at kgdb) --> __touch_softlockup_watchdog()
>> ***(A)--> reset "touch_timestamp" to "get_timestamp()" (Here, the
>> "touch_timestamp" will still be set to 100s.) =C2=A0...
>>
>> =C2=A0 =C2=A0 scheduler_tick() ***(B)--> sched_clock_tick() (update "cpu=
 sched
>> =C2=A0 =C2=A0 clock" to "hardware time" =3D 180s) ... =C2=A0}
>>
>> 5) The Second timer interrupt handler appears to have a large jump and
>> =C2=A0 =C2=A0trips the softlockup warning.
>>
>> update_process_times() { ... =C2=A0run_local_timers() --> softlockup_tic=
k()
>> --> "cpu sched clock" - "touch_timestamp" =3D 180s-100s > 60s --> printk
>> "soft lockup error messages" ... =C2=A0}
>>
>> note: ***(A) reset "touch_timestamp" to "get_timestamp(this_cpu)"
>>
>> Why "touch_timestamp" is 100 sec, instead of 180 sec?
>>
>> With the CONFIG_HAVE_UNSTABLE_SCHED_CLOCK" set the call trace of
>> get_timestamp() is:
>>
>> get_timestamp(this_cpu) -->cpu_clock(this_cpu)
>> -->sched_clock_cpu(this_cpu) -->__update_sched_clock(sched_clock_data,
>> now)
>>
>> The __update_sched_clock() function uses the GTOD tick value to create
>> a window to normalize the "now" values. =C2=A0So if "now" values is too =
big
>> for sched_clock_data, it will be ignored.
>>
>> The fix is to invoke sched_clock_tick() to update "cpu sched clock" in
>> order to recover from this state. =C2=A0This is done by introducing the
>> function touch_softlockup_watchdog_sync(), which allows kgdb to
>> request that the sched clock is updated when the watchdog thread runs
>> the first time after a resume from kgdb.
>>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: peterz@infradead.org
>>
>> ---
>> =C2=A0include/linux/sched.h | =C2=A0 =C2=A04 ++++
>> =C2=A0kernel/kgdb.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A06 +++---
>> =C2=A0kernel/softlockup.c =C2=A0 | =C2=A0 16 ++++++++++++++++
>> =C2=A03 files changed, 23 insertions(+), 3 deletions(-)
>>
>> --- a/kernel/softlockup.c
>> +++ b/kernel/softlockup.c
>> @@ -79,6 +79,14 @@ void touch_softlockup_watchdog(void)
>> =C2=A0}
>> =C2=A0EXPORT_SYMBOL(touch_softlockup_watchdog);
>>
>> +static int softlock_touch_sync[NR_CPUS];
>> +
>> +void touch_softlockup_watchdog_sync(void)
>> +{
>> + =C2=A0 =C2=A0 softlock_touch_sync[raw_smp_processor_id()] =3D 1;
>> + =C2=A0 =C2=A0 __raw_get_cpu_var(touch_timestamp) =3D 0;
>> +}
>> +
>> =C2=A0void touch_all_softlockup_watchdogs(void)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 int cpu;
>> @@ -118,6 +126,14 @@ void softlockup_tick(void)
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 if (touch_timestamp =3D=3D 0) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(softlock_touch_=
sync[this_cpu])) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
/*
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0* If the time stamp was touched atomically
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0* make sure the scheduler tick is up to date.
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0*/
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
softlock_touch_sync[this_cpu] =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
sched_clock_tick();
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> Hm, this looks quite ugly. Peter, Thomas, can you think of a cleaner
> solution?
>

We need not to sync up sched_clock in softlockup_tick, it can just return
and sync up the timestamp in the next tick. This will not touch what should
be done by dynticks, scheduler time and so on and keep softlockup_tick
clean.

I have rewrote the patch based on above, please check the attachment.

Thanks,
Yong

> =C2=A0 =C2=A0 =C2=A0 =C2=A0Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>

--001636e1f9387770a00474724875
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-softlockup-introduce-touch_softlockup_watchdog_sync.patch"
Content-Disposition: attachment; 
	filename="0001-softlockup-introduce-touch_softlockup_watchdog_sync.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g01rz1sv0

RnJvbSAxODIxMzU2NTk2YmRkMjhkZmM2OWY3MDhhNjkyOTM5NGRhMzUxMDAxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFpoYW5nIDx5b25nLnpoYW5nMEBnbWFpbC5jb20+CkRh
dGU6IFNhdCwgMjYgU2VwIDIwMDkgMTA6Mzc6MTQgKzA4MDAKU3ViamVjdDogW1BBVENIXSBzb2Z0
bG9ja3VwOiBpbnRyb2R1Y2UgdG91Y2hfc29mdGxvY2t1cF93YXRjaGRvZ19zeW5jKCkKCkluIGNh
c2Ugb2Ygc3lzdGVtIGhhbHRlZCBmb3IgYSBsb25nIHRpbWUsIHN5c3RlbSB3aWxsCmRvIHRpbWUg
c3luYyB1cCBpbiB0aGUgZmlyc3QgaW5jb21pbmcgdGljay4gQnV0IGlmIHdlCmFsc28gdG91Y2gg
c29mdGxvY2t1cF90aWNrIHRpbWVzdGFtcCBhdCB0aGUgc2FtZSB0aW1lLApzb2Z0bG9ja3VwX3Rp
Y2sgY291bGQga2VlcCBhIG9sZCB0aW1lc3RhbXAgYW5kCnRoaXMgd2lsbCBsZWFkIGFubm95aW5n
IHNvZnRsb2NrdXAgd2FybmluZy4KU28gbW92ZSBzb2Z0bG9ja3VwIHN5bmNpbmcgaXQncyB0aW1l
c3RhbXAgdG8gdGhlIG5leHQKdGljay4KClNpZ25lZC1vZmYtYnk6IEphc29uIFdlc3NlbCA8amFz
b24ud2Vzc2VsQHdpbmRyaXZlci5jb20+ClNpZ25lZC1vZmYtYnk6IERvbmdkb25nIERlbmcgPERv
bmdkb25nLkRlbmdAd2luZHJpdmVyLmNvbT4KQ2M6IEluZ28gTW9sbmFyIDxtaW5nb0BlbHRlLmh1
PgpDYzogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPgpMS01MLVJlZmVyZW5j
ZTogPGh0dHA6Ly9sa21sLm9yZy9sa21sLzIwMDkvNy8yNy8zMTc+ClNpZ25lZC1vZmYtYnk6IFlv
bmcgWmhhbmcgPHlvbmcuemhhbmcwQGdtYWlsLmNvbT4KLS0tCiBpbmNsdWRlL2xpbnV4L3NjaGVk
LmggfCAgICA0ICsrKysKIGtlcm5lbC9zb2Z0bG9ja3VwLmMgICB8ICAgMTggKysrKysrKysrKysr
KysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9zY2hlZC5oIGIvaW5jbHVkZS9saW51eC9zY2hl
ZC5oCmluZGV4IDc1ZTZlNjAuLjFhYTQ1NzQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvc2No
ZWQuaAorKysgYi9pbmNsdWRlL2xpbnV4L3NjaGVkLmgKQEAgLTMwNyw2ICszMDcsNyBAQCBleHRl
cm4gdm9pZCBzY2hlZF9zaG93X3Rhc2soc3RydWN0IHRhc2tfc3RydWN0ICpwKTsKICNpZmRlZiBD
T05GSUdfREVURUNUX1NPRlRMT0NLVVAKIGV4dGVybiB2b2lkIHNvZnRsb2NrdXBfdGljayh2b2lk
KTsKIGV4dGVybiB2b2lkIHRvdWNoX3NvZnRsb2NrdXBfd2F0Y2hkb2codm9pZCk7CitleHRlcm4g
dm9pZCB0b3VjaF9zb2Z0bG9ja3VwX3dhdGNoZG9nX3N5bmModm9pZCk7CiBleHRlcm4gdm9pZCB0
b3VjaF9hbGxfc29mdGxvY2t1cF93YXRjaGRvZ3Modm9pZCk7CiBleHRlcm4gaW50IHByb2NfZG9z
b2Z0bG9ja3VwX3RocmVzaChzdHJ1Y3QgY3RsX3RhYmxlICp0YWJsZSwgaW50IHdyaXRlLAogCQkJ
CSAgICB2b2lkIF9fdXNlciAqYnVmZmVyLApAQCAtMzIwLDYgKzMyMSw5IEBAIHN0YXRpYyBpbmxp
bmUgdm9pZCBzb2Z0bG9ja3VwX3RpY2sodm9pZCkKIHN0YXRpYyBpbmxpbmUgdm9pZCB0b3VjaF9z
b2Z0bG9ja3VwX3dhdGNoZG9nKHZvaWQpCiB7CiB9CitzdGF0aWMgaW5saW5lIHZvaWQgdG91Y2hf
c29mdGxvY2t1cF93YXRjaGRvZ19zeW5jKHZvaWQpCit7Cit9CiBzdGF0aWMgaW5saW5lIHZvaWQg
dG91Y2hfYWxsX3NvZnRsb2NrdXBfd2F0Y2hkb2dzKHZvaWQpCiB7CiB9CmRpZmYgLS1naXQgYS9r
ZXJuZWwvc29mdGxvY2t1cC5jIGIva2VybmVsL3NvZnRsb2NrdXAuYwppbmRleCA4MTMyNGQxLi42
MjhkNTMxIDEwMDY0NAotLS0gYS9rZXJuZWwvc29mdGxvY2t1cC5jCisrKyBiL2tlcm5lbC9zb2Z0
bG9ja3VwLmMKQEAgLTI1LDYgKzI1LDcgQEAgc3RhdGljIERFRklORV9TUElOTE9DSyhwcmludF9s
b2NrKTsKIHN0YXRpYyBERUZJTkVfUEVSX0NQVSh1bnNpZ25lZCBsb25nLCB0b3VjaF90aW1lc3Rh
bXApOwogc3RhdGljIERFRklORV9QRVJfQ1BVKHVuc2lnbmVkIGxvbmcsIHByaW50X3RpbWVzdGFt
cCk7CiBzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IHRhc2tfc3RydWN0ICosIHdhdGNoZG9n
X3Rhc2spOworc3RhdGljIERFRklORV9QRVJfQ1BVKGJvb2wsIHNvZnRsb2NrX3RvdWNoX3N5bmMp
OwogCiBzdGF0aWMgaW50IF9fcmVhZF9tb3N0bHkgZGlkX3BhbmljOwogaW50IF9fcmVhZF9tb3N0
bHkgc29mdGxvY2t1cF90aHJlc2ggPSA2MDsKQEAgLTc5LDYgKzgwLDEzIEBAIHZvaWQgdG91Y2hf
c29mdGxvY2t1cF93YXRjaGRvZyh2b2lkKQogfQogRVhQT1JUX1NZTUJPTCh0b3VjaF9zb2Z0bG9j
a3VwX3dhdGNoZG9nKTsKIAordm9pZCB0b3VjaF9zb2Z0bG9ja3VwX3dhdGNoZG9nX3N5bmModm9p
ZCkKK3sKKwlfX3Jhd19nZXRfY3B1X3Zhcih0b3VjaF90aW1lc3RhbXApID0gMDsKKwlfX3Jhd19n
ZXRfY3B1X3Zhcihzb2Z0bG9ja190b3VjaF9zeW5jKSA9IHRydWU7Cit9CitFWFBPUlRfU1lNQk9M
KHRvdWNoX3NvZnRsb2NrdXBfd2F0Y2hkb2dfc3luYyk7CisKIHZvaWQgdG91Y2hfYWxsX3NvZnRs
b2NrdXBfd2F0Y2hkb2dzKHZvaWQpCiB7CiAJaW50IGNwdTsKQEAgLTExNyw2ICsxMjUsMTUgQEAg
dm9pZCBzb2Z0bG9ja3VwX3RpY2sodm9pZCkKIAkJcmV0dXJuOwogCX0KIAorCS8qCisJICogSWYg
dGhlIHNjaGVkdWxlciB0aWNrIGlzIG5vdCB1cCB0byBkYXRlLiBTa2lwIHRoaXMgY2hlY2sKKwkg
KiBhbmQgd2FpdCBmb3IgdGhlIHRpbWVzdGFtcCB0byB0byBzeW5jZWQgaW4gdGhlIG5leHQgdGlj
aworCSAqLworCWlmICh1bmxpa2VseShwZXJfY3B1KHNvZnRsb2NrX3RvdWNoX3N5bmMsIHRoaXNf
Y3B1KSkpIHsKKwkJcGVyX2NwdShzb2Z0bG9ja190b3VjaF9zeW5jLCB0aGlzX2NwdSkgPSBmYWxz
ZTsKKwkJcmV0dXJuOworCX0KKwogCWlmICh0b3VjaF90aW1lc3RhbXAgPT0gMCkgewogCQlfX3Rv
dWNoX3NvZnRsb2NrdXBfd2F0Y2hkb2coKTsKIAkJcmV0dXJuOwpAQCAtMjE2LDYgKzIzMyw3IEBA
IGNwdV9jYWxsYmFjayhzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5mYiwgdW5zaWduZWQgbG9uZyBh
Y3Rpb24sIHZvaWQgKmhjcHUpCiAJCQlyZXR1cm4gTk9USUZZX0JBRDsKIAkJfQogCQlwZXJfY3B1
KHRvdWNoX3RpbWVzdGFtcCwgaG90Y3B1KSA9IDA7CisJCXBlcl9jcHUoc29mdGxvY2tfdG91Y2hf
c3luYywgaG90Y3B1KSA9IGZhbHNlOwogCQlwZXJfY3B1KHdhdGNoZG9nX3Rhc2ssIGhvdGNwdSkg
PSBwOwogCQlrdGhyZWFkX2JpbmQocCwgaG90Y3B1KTsKIAkJYnJlYWs7Ci0tIAoxLjYuMC40Cgo=
--001636e1f9387770a00474724875--
