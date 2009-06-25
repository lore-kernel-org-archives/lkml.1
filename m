Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZFYKOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZFYKOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZFYKOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:14:06 -0400
Received: from senator.holtmann.net ([87.106.208.187]:46509 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZFYKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:14:04 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
 usage
From: Marcel Holtmann <marcel@holtmann.org>
To: Dianne Hackborn <hackbod@android.com>
Cc: Daniel Walker <dwalker@fifo99.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <26b7c7380906242109id89b490m2c148ec0ac9b3696@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245458940.32124.45.camel@desktop>
	 <26b7c7380906242109id89b490m2c148ec0ac9b3696@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 12:14:08 +0200
Message-Id: <1245924848.12994.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dianne,

> > Most of these questions related to the fact that I don't think an
> > interface like this just slips into the kernel as a driver. Since it's
> > IPC, it's totally generic, and it's not part of a standard (i.e. POSIX),
> > we need to have some better and more specific information about it (or
> > atleast I do).
> 
> Hi, sorry I have been slow to respond.  I can give a summary of how
> binder is used in the Android platform and the associated feature set.
>  I won't try to address other options, especially D-Bus, because
> honestly I haven't been following it for the last 3 or so years so
> don't really know its current state of art.

let see how we can compare it to D-Bus right now.

> In the Android platform, the binder is used for nearly everything that
> happens across processes in the core platform.  Some examples of this,
> illustrating key features are:
> 
> - The window manager and clients talk with each other through Binder.
> When a client starts up, it does a binder IPC into the window manager
> to create a new binder connection dedicated to that client.  This is a
> common use of the capability model of the binder, where secure
> connections are given to clients which they can use for communication
> with the system.

That is exactly what D-Bus is used for by any other Linux system. And
embedded examples are the Nokia N810 and Palm Pre. To name only two
since there are more.

> - The window manager and lower-level surface compositor talk with each
> other through Binder.  There is as simple binder-based API that is
> used to allocate a surface for a window.  This takes advantage of the
> Binder's fd passing and object identity facilities to allow the
> surface compositor to allocate area in a shared heap it manages: the
> window manager makes this request on behalf of a client application,
> and then passes that binder object over to the client process (it will
> retrieve the associated fd and map it for each unique heap it
> receives) for it to draw directly into the associated surface memory.
> The binder's object identity rules (an object has a single identity as
> it travels across processes, no matter how many times it does so or
> where it goes) are very convenient for managing this.

Patches for D-Bus with file descriptor passing have been posted. So that
feature is available.

> - Separate components, like the window manager or surface flinger, may
> be switched between running in the same process or different processes
> with no change to their code.  For example, in the current android
> platform these two components run in the same process, but we also
> have had run them in other processes and would like to do so on
> higher-end systems where there is more memory.  This is not strictly a
> feature of the kernel part of the binder, but the IPC semantics it
> provides greatly ease its implementation: dispatching transactions to
> thread pools, synchronous calls with recursion across processes, etc.

D-Bus provides namespacing based on service name, interface names and
object paths. So you can combine applications into one binary if you
want to.

> - The activity (or really application/process) manager also uses the
> binder for launching and managing components in a process.  For
> applications, it creates a simple binder object for use as a "token"
> for the application.  It gives this token to both the application and
> the window manager, and the application gives its token to the window
> manager when it adds windows.  Because the binder maintains object
> identity, this model is used extensively in the system for security:
> you can hand someone a token, and then can hand that token to others,
> and you can always check whenever you get a token exactly who it was
> originally given to without any way for clients to spoof it.  So the
> activity manager can say to the window manager, "all of this token's
> windows should be hidden," and the window manager can absolutely
> identify which windows came from that application through the token
> the app supplied with them.

D-Bus has unique bus names for all application connecting to the bus. It
can be used to detect startup and termination of apps. The Bluetooth
stack for example makes massive use of this to cleanup after broken UI
application.

Also D-Bus supports system and session bus activation. So it can start
applications and daemons.

> - The fundamentals of Android's security are a combination of
> uid-based permissions and binder capabilities.  Some capabilities are
> direct (I give you access to my interface that you can call on), some
> are indirect (I give you a binder object as a token that you can
> compare against other tokens you receive to validate who it is).  For
> permissions, every incoming binder transaction has associated with it
> the uid of the initator, which is used in numerous places where we
> want to only allow specific uids to access specific features.  For
> example, there are APIs on the window manager to inject high-level
> input events into the system, and the implementation of those methods
> checks the calling uid to see if it is an application that has been
> granted the permission to do this.

D-Bus integrates with SELinux which is way superior than any UID based
approach anyway. It also has its own authentication scheme and with the
help of PolicyKit system wide access policies can be implemented and
extended at runtime by privileged users.

> - The binder natively supports one-way and two-way calls.  Its two-way
> calls are used extensively by all of the system services for incoming
> IPCs for better multi-threading: they are dispatched directly from a
> thread pool and the services acquire specific locks as needed to
> protect their state (rather than serializing all calls through one
> thread).  More traditional one-way/async calls are used for
> communicating back with applications (or really for any service to
> send commands to a higher-level part of the system).

I have no idea on how to compare this and what kind of advantage this
should be.

Within D-Bus every message is async and some of them are method call
with a reply message or errors or signals.

> - Many of the system services of course want to clean up state they
> have associated with a client process.  For example, if an application
> process goes away, all of its windows should be removed.  This is made
> easy by the binder's "link to death" facility, which allows a process
> to get a callback when another process hosting a binder object goes
> away.  For example, the window manager links to the death of a
> window's callback interface, and other services have clients send a
> binder object token just to be able to find out when its process dies.
>  The driver provides this facility by telling a process about the
> death of any objects it is watching.

That can be done with D-Bus via the NameOwnerChanged signal and the
unique bus name. As mentioned above the Bluetooth subsystem makes
massive use of this feature.

> - The Input Method Manager is probably one of the better
> representative examples of how the binder facilities are used in the
> system: it is a relatively small component, but makes extensive use of
> binder object identities, capabilities, death links, and other
> features to arbitrate between N applications and M IMEs securely
> interacting with each other in a controlled way.  A taste of this can
> be seen in the "Security" section of
> http://developer.android.com/reference/android/view/inputmethod/InputMethodManager.html
> .  One particular feature it relies on is allowing an application to
> hand it a binder object for an interface (here an InputConnection),
> which it can then send to an IME running in another process.  That IME
> can now make direct calls on the InputConnection for just that
> application (it has been granted that capability) without having to go
> through the Input Method Manager intermediary process.

The Linux desktop systems use D-Bus a lot. Some use more features than
other. Feel free to look at it.

> One part of the binder protocol that is really nice but doesn't yet
> have a user space implementation is weak references.  This allows a
> process to maintain knowledge of a remote object, without forcing it
> to stay around.  At any point it can try to promote that to a strong
> reference (to actively call on the object), which will either succeed
> or fail based on whether the original object is still around or is not
> around because all of the strong references (either in-proc or remote)
> are gone.  We never re-implemented the user space code for this
> because we didn't do weak references in the Java layer, but for native
> C and C++ code it is a very nice facility for managing object
> lifetimes.

I am not sure what this is good for. Especially since you didn't expose
it in the Java layer anyway.

D-Bus has system and session activation which can be used to start/stop
application based on service names. A D-Bus service name can also be
pending and waiting for the previous owner to terminate and then it will
take over. Some sort of failsafe if you want.

> For a rough idea of the scope of the binder's use in Android, here is
> a list of the basic system services that are implemented on top of it:
> package manager, telephony manager, app widgets, audio services,
> search manager, location manager, notification manager, accessibility
> manager, connectivity manager, wifi manager, input method manager,
> clipboard, status bar, window manager, sensor service, alarm manager,
> content service, activity manager, power manager, surface compositor.

I am not doing the Linux list since that would take me longer than a day
to compile and would forgot some of the apps ;)

> > If for instance the main reason for Google using this interface is cause
> > a large number of android people once worked at Palm or BeOS, that's not
> > reason enough for it to go into the kernel. Or if this binder interface
> > really fits well with Java or C++ people and they just love it, that's
> > not really acceptable either..
> 
> It is true that a lot of the ideas of the binder came from previous
> work on BeOS and Palm's Cobalt.  However, that is mostly inspiration:
> we started with the Open Binder code for very intial bringup, but
> entirely rewrote both the user space and driver code to address our
> needs for Android and to better fit with the Linux-centric design of
> the platform.
> 
> I'm not sure what the relevance is of Java or C++ people liking it.
> Does this mean that the important thing is that C people love it and
> other languages don't matter? :)  Anyway whether or not you "love" it
> I don't think is a matter of programming language but just design
> style, personal preference, and who knows what else.  It has been
> extremely useful in our implementation of Android, as can be seen in
> just how much of the system sits on top of it, but that's all.
> 
> Finally as far as someone else's comment of Open Binder being dead --
> well it's an interesting situation.  That particular code is no longer
> being developed, but basically the active development switched over to
> the fork/rewrite of it we have now in Android.  You could maybe say
> that Open Binder was a research project, and Android is the shipping
> implementation.  Though really, the main difference between them is
> that Android has a much simpler user-space implementation (because we
> didn't need the full features of Open Binder); there isn't any reason
> the full Open Binder environment couldn't be put back on top of the
> current binder.  The binder shell is certainly a fun toy. :)  See
> http://www.open-binder.org/docs/html/BinderShellTutorial.html for
> example.  But a lot of the stuff there is just not hugely interesting
> for Linux/Android.

The thing that I don't understand is why you bothered to re-write Binder
and not just use D-Bus. Especially since D-Bus is part of Android
anyway, because of BlueZ.

To me it seems everything that you want from Binder is already possible
with D-Bus. Seems the only missing piece is to create dbus-daemon as a
kernel subsystem so it is available for all userspace processes from the
beginning (including init/upstart).

Regards

Marcel


