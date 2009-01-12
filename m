Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZALPTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZALPTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZALPSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:18:51 -0500
Received: from mail-forward1.uio.no ([129.240.10.70]:56669 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZALPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:18:50 -0500
X-Greylist: delayed 1056 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 10:18:49 EST
Message-ID: <496B59B7.3010302@simula.no>
Date: Mon, 12 Jan 2009 15:54:47 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: linux-net@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, mdavem@davemloft.net, jgarzik@pobox.com,
       kohari@novell.com, peterz@infradead.org, jzemlin@linux-foundation.org,
       mrexx@linux-foundation.org, tytso@mit.edu, mingo@elte.hu,
       kristrev@simula.no, griff@simula.no, paalh@ifi.uio.no,
       Netdev <netdev@vger.kernel.org>, shemminger@vyatta.com
Subject: Re: RFC: Latency reducing TCP modifications for thin-stream interactive
 applications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: DE9BE559B4725AE9DA825E3E3B1B61AFBED4005B
X-UiO-SPAM-Test: remote_host: 129.240.228.26 spam_score: -49 maxlevel 200 minaction 1 bait 0 mail/h: 36 total 11683 max/h 154 blacklist 0 greylist 1 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for comprehensive feedback. We're sorry it took so long to reply.
We will begin the work on a patch set against the net-next tree now and 
try to follow your formatting and functional advice.

Ilpo Järvinen wrote:
> linux-net is users list, use netdev instead on matters relating
> development...

Bad case of typo :)

>
> Please make sure that it's based on net-next tree next time since there
> are lots of changes already in the areas you're touching.

We will do that for the updated patch set.

>> This will also give us time to integrate any ideas that may arise from
>> the discussions here.
>>
>> We are happy for all feedback regarding this:
>> Is something like this viable to introduce into the kernel?
>>
> No idea in general. But it has to be (nearly) minimal and clean if such
> thing is ever to be considered. The one below is definately not even close
> minimal in many areas...

We will clean up the noise, redo the formatting and divide it into logical 
segments for the new patch set.

>> Is the scheme for thin-stream detection mechanism acceptable.
>
> Does reduncancy happen in the initial slow start as well (depends on
> write pattern)? Why it is so in case the stream is to become thick
> right after initial rtts?
>

If the window is halved, (but still not at less than 4 segment), the mechanisms
will be turned off (due to the < 4 packets in flight limit). If the stream backs off
to a minimal window, the mechanisms will be turned on.

The bundling mechanism (if activated) will stay active since it relies on
the packet sizes and interarrival time, not on number of packets in flight.

> ...In general this function should be split, having a separate skb
> (non-TCP) function(s) and tcp-side would be ideal.
>
> It's misnamed as well, it won't merge but duplicates?
>
> Also, this approach is extremely intrusive and adding non-linear seqno
> things into write queue will require _you_ to do _full audit_ over every
> single place to verify that seqno leaps backwards won't break anything
> (and you'll still probably miss some cases). I wonder if you realize
> how easily this kind of change manifests itself as a silent data
> corruption on stream level and have taken appropriate actions to validate
> that not a single one of scenario leads to data coming as different out as
> was sent in (every single byte, it's not enough to declare that
> application worked which could well happen with corrupted data too). TCP
> is very coreish and such bugs will definately hit people hard.
>

We have to admit we don't quite see the problem. Since a page can never be removed
before all owners have decleared that they no longer needs it, all data will be correctly 
present. Also, since the packets are placed linearly on the queue and we don't support 
when SACK is enabled, no gaps will occur. But maybe we have misunderstood your 
comment, please let us know if that is the case.


>> + if(TCP_SKB_CB(skb)->seq <= (TCP_SKB_CB(prev_skb)->end_seq - ua_data)){
>
> So ua_data must be prev_skb->len or this fails? Why ua_data needs such
> complex setup above?
>

>
> Does this thing of youes depend on skb being not cloned?
>

We will look into making the calculation ua_data easier and also the cloning requirement. The check 
is there to avoid duplicate data in the case when a previous packet has been bundled with later ones. 
However, when we think about it, this might not be neccessary since bundling on retransmission is not 
allowed to bundle with packets that are yet to be sent. Thank you for pointing this out.

>> +
>> + if ((tp->thin_rdb || sysctl_tcp_force_thin_rdb) && skb == tcp_send_head(sk)) {
>> + tcp_advance_send_head(sk, skb);
>> + }
>> +
>
> I kind of missed the point of this change, can you please justify it if
> it's still needed? I think it must either be bug in your code causing this
> to happen or unnecessary.
>

Thank you very much, this was placed there for a part of the development that we found out
was unecessary.

>> + * Make sure that the first skb isnt already in
>> + * use by somebody else. */
>> +
>> + if (!skb_cloned(skb)) {
>
> Relying on skb's not being cloned will make your change to work in a
> minority of the cases on many hardwares that have tx reclaims happening
> late enough. I recently got some numbers about clones after rtt and can
> claim this to happen for sure!
>

We were not aware of this and will look into the whole cloned-thin in this patch.

>> +
>> + if(skb_shinfo(skb)->frag_list || skb_shinfo(skb)->frag_list){
>
> If it wasn't cloned, why you do this check?
>

Good question, oversight by us, thank you for pointing it out.

> I suppose this function was effectively:
>
> {
> tcp_write_queue_walk_safe(...) {
> ...checks...
> if (tcp_trim_head(...))
> break;
> tcp_collapse_retrans(...);
> }
> }

Correct, except we dont collapse but bundle, will be modified and simplified in the next version of the patch.

> It's sort of counter-intuitive that first you use redundancy but now in
> here when the path _has shown problems_ you now remove the redundancy if
> I understand you correctly? The logic is...?
>

Even though the path has problems (as shown by the need for retransmission), we still bundle as many 
packets as possible. If you are still not sure, please let us know what part of the code that is confusing.

> It seems very intrusive solution in general. I doubt you succeed in
> pulling it off as is without breaking something. To me it seems rather
> fragile approach to make write queue seqno backleaps you're proposing. It
> also leads to troubles in the truesize as you have noticed. Why not just
> building those redundancy containing segments at the write time in case
> the stream is thin, then all other parts would not have to bother about
> dealing these things? Number of sysctls should be minimized, if they're
> to be added at all. Skb work functions should be separated from tcp layer
> things.
>
> If you depend on non-changing sysctl value to select right branch, you're
> asking for trouble as the userspave is allowed to change it during the
> flow as well and even during the ack processing.
>

As far as we understand this comment, you want us to do it on the application layer instead? Do you mean as a 
middleware, application-specific solution or something similar? Also, we believe doing it on the application layer 
will lead to the same delays that we try to prevent, since sent data will be delayed on the transport layer in case 
of loss.

-Andreas Petlund & Kristian Evensen
