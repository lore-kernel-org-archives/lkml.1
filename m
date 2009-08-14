Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbZHNPqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbZHNPqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbZHNPqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:46:37 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:53497 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbZHNPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:46:36 -0400
MIME-Version: 1.0
In-Reply-To: <20090814133225.GB27905@us.ibm.com>
References: <2359eed20908132115t2f6cea3by2429d54914d5ac6f@mail.gmail.com>
	 <20090814133225.GB27905@us.ibm.com>
Date: Fri, 14 Aug 2009 10:40:46 -0500
Message-ID: <2359eed20908140840u2886b8dci4ce72914fc2b1ea9@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/1] support optional non-VFS capability inheritance 
	without disabling file caps
From: Will Drewry <redpig@dataspill.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org, morgan@kernel.org,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 8:32 AM, Serge E. Hallyn<serue@us.ibm.com> wrote:
> Quoting Will Drewry (redpig@dataspill.org):
[snip]
>> This allows for a purely runtime capabilities-based environment without
>> requiring every file to be annotated with an extended attribute.  This
>
> Well, we have that ability now - only files which need to be executed
> *with* *privilege* need an xattr.

Of course - I was thinking of it in terms of temporally restricted
(runtime) instead of reapplied by the fs on each go which I realize is
directly opposed to the idea of the executable itself having the
privileges.

>> also means that SECURE_NOROOT process trees using capabilities become
>> more accessible, especially for filesystems without extended attribute
>> support - or in mixed FS environments.
>
[snip]
> Heck, maybe we can use the fscache or a stackable fs to provide a view
> of a non-xattr fs with xattrs layered on top.  David Howells, does
> that sound doable or would that be an abuse?

I haven't looked at much fscache (but I look forward to hearing back), but
a stackable fs might make sense.  A simple way to layer xattrs on top
of any filesystem would be a welcome transititory step for a xattr-less
filesystem, but it could be a bit clumsy.

> Will, let me be sure we're on the same page - you don't want this feature
> bc you don't want to go through the trouble of adding file capabilities
> to the executables which need and deserve it, but because in your
> environment you have an FS which doesn't support file caps and so
> there is no way for you to have a SECURE_NOROOT|SECURE_NOSUID_FIXUP
> environment because you need to run a privileged program off of the
> non-xattr fs?

Yes and more. On one side, I am looking to run privileged programs from
a non-xattr fs in a SECURE_NOROOT|SECURE_NOSUID_FIXUP environment, but I
am also interested in granting capabilities contextually where the
context is the specific process ancestry.  In many cases, a binary
with a capability xattr doesn't need extra privileges all the time
but only when called via an expected path.

That approach would make it possible to use a smaller, well-audited
binary that can grant capabilities from their bounding set _only_ when
it makes the decision to do so (suidwrapper-style, I guess).  If the
system supports xattrs, then it would mean this binary gets
xattr-flagged and not the actual code.  (This can be synthesized by
having a daemon use setfcaps to toggle the setting on a file during
execution which, at worst, would yield a race condition, but probably
nothing too terrifying...)

>> Nb, I may be missing something obvious - any insights will be appreciated,
>>     and there is a good bit of flexibility in what can be done here.
>
> I don't know whether or not you're missing something, but of course
> what we give up with your patch is the feature that all privilege to
> a process is in the end granted by the executable.  I'll admit that
> of the like patches I've seen, yours makes the most sense.  My main
> concern would be that it would make things more confusing, so if we
> can fix the problem another way, without adding yet another set of
> semantics, that would be preferable.  However if that is not feasible,
> I might be inclined to ack this.

I can definitely see the room for confusion - at any point, you'd need
to take a getcaps(pstree) to see your current capability state (or
have a process-cred-enumerating module).  Right now, you only need to
do that if you'd like to know the current inherited capability state.
That's part of the reason why I thought it'd be important to treat this
as a separate mode of operation for a process tree via securebits.
Hopefully the guard bit will keep pure, xattr-based use unmuddied by
this hybrid process-driven capability model.

A stackable filesystem seems like it could provide a nice stepping stone
for xattr-less filesystems, but implementing one with
xattrs-based-on-calling-process would be more convoluted imho without
patching more code to be capability aware (or making a crazy
process-tree walking stackable fs with a proc/ioctl/whatever interface
for setting the equivalent securebit for a process tree :).

If all current daemons were capability-aware, then a +i tree would be
possible where a process transitioning to SECURE_NOROOT|NOFIXUP could
leave all later expected capabilities as +i, then any 'potentially' a +i
and then when the +i xattr exists on a file (via the stackable fs).

I would understand if you don't think that is compelling enough to merit
an additional mode of operation, but I hope that it expands the utility
of the capability system without too much fuss.
[unless a better solution really is available]

Thanks!
will
