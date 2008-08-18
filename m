Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbYHRB0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbYHRB0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYHRB0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:26:14 -0400
Received: from mail.lang.hm ([64.81.33.126]:43101 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYHRB0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:26:12 -0400
Date: Sun, 17 Aug 2008 18:25:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Casey Schaufler <casey@schaufler-ca.com>, Peter Dolding <oiaohm@gmail.com>,
       rmeijer@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>,
       Arjan van de Ven <arjan@infradead.org>
Subject: scanner interface proposal was: [TALPA] Intro to a linux interface
 for on access scanning (fwd)
Message-ID: <alpine.DEB.1.10.0808171824060.12859@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trying to resend again due to tripping L-K anti-spam filtering

since many people apparently missed this writeup I'm re-sending it.

please try to seperate disagreement with the threat model this is addressing 
with disagreement with the design.

comments since I sent this out on friday seem to fall in three catagories

1. people didn't read it

   this is why I'm re-sending this

2. disagreement with the idea that the on-access part can be triggered in 
userspace

   this is a valid debate to have, but it's tied to #3

3. (and the biggest batch) statements that this won't protect against problem X 
(where X was not in the threat model)

   arguing againt this design is the wrong thing to do. argue against the threat 
model instead, preferrably by proposing a different threat model and allowing 
for a debate of which is appropriate.

the threat model that was sent out (by others, not by me) basicly boils down to 
"don't allow programs to access/execute 'unscanned' data. don't try to defend 
against actions of programs already running or malicious user actions" there 
were further comments listing things it's not trying to cover.

David Lang

On Fri, 15 Aug 2008, Arjan van de Ven wrote:

> The implementation idea (have a flag/generationnr in the inode for
> 'known good', block on read() and mmap(), and schedule async scans in
> open or on dirty) seems to be quite solid although several details
> (async queueing model for example but also the general dirty
> notification system) need to be worked out.

I really think that we need to avoid trying to have a single 'known good' 
flag/generationnrwith the inode.

while that will work for the TALPA use-case of a single anti-virus scanner, it 
can't cope with multiple scanners, and since there are very different types of 
scanners that are interesting (anti-virus and indexing to just name two), and 
the fact that some people will want to run more then one anti-virus program on 
a machine, you don't have a 'known good' condition, you have 'known good 
according to program A/B/C' conditions, and the file should only be considered 
'good, nothing to do' if it has a full set of flags.

and these flags really should live on disk. many types of scans really are 
still relavent across reboots, and even where you can make arguments that "the 
user may have booted into another OS and infected the file" the counter 
argument "you don't want to waste battery power scanning something every time 
you boot when you don't use another OS" can be applied.

if you store generation numbers for individual apps (in posix attributes to 
pick something that could be available across a variety of filesystems), you 
push this policy decision into userspace (where it belongs). users who are 
paranoid can have the AV software incrament it's generation number on every 
boot so that all of the prior tags are considered worthless, while users who 
are more worried about battery power can completely disable background scanning 
while on battery, and trust to the fact that most of the files are already 
flagged as safe to minimize the amount of new scanning that needs to be done. 
(and don't tell me about how frequently the signatures are updated, if someone 
is on a 12 hour flight without Internet access they are not going to be having 
new virii hitting them, let alone downloading new signature files)

so I propose the following approach (mentioned at least in pieces over the last 
couple of days, but consolodated and cleaned up a bit)

1. define a tag namespace associated with the file that is reserved for this 
purpose for example "scanned-by-*"

2. have an kernel option that will clear out this namespace whenever a file is 
dirtied

3. have a kernel mechanism to say "set this namespace tag if this other 
namespace tag is set" (this allows a scanner to set a 'scanning' tag when it 
starts and only set the 'blessed' tag if the file was not dirtied while it was 
being scanned. without this there is a race condition that could cause a file 
to be marked as good incorrectly, the initial threat model ruled out worrying 
about race conditions, but this seems like a fairly easy one to close

4. have a mechanism (netlink?) where multiple programs can connect to receive 
near-real-time notification that a file changed state from partially/fully 
scanned to dirty. (don't try to report what has changed, just that it is 
changed status to dirty). This report should contain the filesystem, inode, 
path, and namespace information needed to access and identify the file

5. define a "must pass" 'policy file' path that the various scanner programs 
can set the "scanned-by-*" flags on that the 'libmalware' library will look at 
to see what needs to be set for a file to be considered 'good', along with a 
path for a program that should be called if the flag is not set. (this path 
could be a directory with one symlink per scanner, the name of the file being 
the flag name)

6. create a library that replaces open/read/etc with versions that imlement a 
pam-style stack of hooks that scanning programs can be configured to use. like 
pam these programs can return "I say this is bad", "no comment/looks good", or 
"I say this is safe". config files can then set the order of these scanns and

Scanning software can use the hooks above to implement every behavior that I've 
seen mentioned in this thread.

A. filesystem indexing programs can subscribe to the notification mechanism and 
set a "scanned-by'*" flag as they touch files, but not register themselves as 
something that needs to be checked when a file is opened.

B. tripwire type programs can set flags as they scan the system, subscribe to 
the notification mechanism, register with the "must pass" list, and when 
invoked give a quick "I know this is safe", or "this wasn't supposed to change, 
something is wrong" response if the file is something it knows about, or "no 
comment otherwise

C. anti-virus scanners can subscribe to the notification mechanism, register 
with the "must pass" list, and when invoked do their checks and report "I found 
something bad, deny access" or "no comment/looks good" depending on what they 
find.

D. anti-virus scanners could choose to ignore the notification mechansim, 
register with the "must pass" list, and only scan files that are being 
accessed, never do any background scanning (appropriate for software who's 
signature files change very frequently where you don't want to try and scan 
everything between updates)

E. most people will have a default allow module loaded at the end of the "must 
check" chain, but _really_ paranoid people could instead have a module that 
determines if the file was expected to exist, and if not deny access to it

F. becouse the checking is a userpace library, distros can choose any balace 
between 'every binary does the checks' to 'only the Samba binaries do checks', 
and could add an option to open/read/etc to allow a program to say "I don't 
need you to scan the file" (for example, why would "wc" need it's input 
scanned?). this also provides a solid mechanism to avoid recursive calls to the 
scanning programs, they just choose not to do the scanning checks.

G. becouse the scanners are userspace, they can get configured to run as the 
user who called them (nessasary if they are to scan files only available to 
that user) or they can be configured to run as root (suid or other mechanism)

H. becouse the scanners are userspace, all decisions of how to schedule the 
bckground scanning are up to the software and administrator.

I. becouse there are hooks at each of the commands (open/read/etc) the 
userspace can choose what to do at each step (it may schedule a async scan for 
'right now' on open, and then block on read until the file is scanned)

J. becouse the "scanned-by-*" namespace is deliberatly not defined scanners can 
set flags as needed for intermedate status (register "scanned-by-macafee1234" 
on the "must pass" list, but set a "scanned-by-macafee1234-in-progress" flag to 
avoid multiple scanners from working over the same file (as well as avoiding 
the race of the file being modified as it's being scanned)

K. becouse the scanner and checks are in userspace and initally are called in 
the context of the user running the program trying to do the access, it's 
possible for them to do things like 'do you want to' pop-ups, progress bars, 
etc

L. the fact that knfsd would not use this can be worked around by running FUSE 
(which would do the checks) and then exporting the result via knfsdw

M. becouse the checks are in userspace, it's easy to create 'whitelist' 
scanners (either by name "never bother scanning /var/lob/messages, no matter 
how many times it gets marked dirty" or by SELinux tags "never bother to scan 
anything unless it has the SELinux tag that says it came from a untrusted 
source)

N. becouse the checker/scanners start in the context of the program trying to 
do the access it's possible to access the fd being accessed, even if the file 
no longer exists on the filesystem (closing the hole of opening a file that 
wasn't scanned, unlinking it, then reading the resulting file). This is outside 
of the threat model that was proposed, but still possible to do with this model

what is not covered by this design that is covered by the threat model being 
proposed?

what did I over complicate in this design? or is it the minimum feature set 
needed?

are any of the features I list impossible to implement?

David Lang
