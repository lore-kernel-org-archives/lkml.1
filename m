Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYKJKfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYKJKfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYKJKfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:35:31 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:51888 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYKJKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:35:28 -0500
Message-ID: <49180E6E.7080906@nttdata.co.jp>
Date: Mon, 10 Nov 2008 19:35:26 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for TOMOYO
 Linux.
References: <20081104060847.086543472@nttdata.co.jp>	<20081104060951.618445959@nttdata.co.jp> <20081105151221.d605226f.akpm@linux-foundation.org>
In-Reply-To: <20081105151221.d605226f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2008 10:35:25.0024 (UTC) FILETIME=[0A753E00:01C94320]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > +static bool is_byte_range(const char *str)
> > +{
> > +	return *str >= '0' && *str++ <= '3' &&
> > +		*str >= '0' && *str++ <= '7' &&
> > +		*str >= '0' && *str <= '7';
> > +}
> 
> Well... why?
> 
> I cannot think of any kernel interfaces which use octal strings.  What
> is special about Tomoyo?
> 
TOMOYO uses \ooo style representation for 0x01 - 0x20 and 0x7F - 0xFF.
This function verifies that \ooo is in valid range.

> > +static bool is_decimal(const char c)
> > +{
> > +	return c >= '0' && c <= '9';
> > +}
> 
> This duplicates a standard ctype.h function.
> 
Replaced "is_decimal" by "isdigit".

> > +static bool is_hexadecimal(const char c)
> > +{
> > +	return (c >= '0' && c <= '9') ||
> > +		(c >= 'A' && c <= 'F') ||
> > +		(c >= 'a' && c <= 'f');
> > +}
> 
> And so does this.
> 
Replaced "is_hexadecimal" by "isxdigit".

> > +static bool is_alphabet_char(const char c)
> > +{
> > +	return (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f');
> > +}
> 
> As does this.
> 
Oops! "(c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f');" was wrong. X-p
It is "(c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');".
But, not found in a standard ctype.h function.

> > +static bool str_starts(char **src, const char *find)
> > +{
> > +	const int len = strlen(find);
> > +	char *tmp = *src;
> > +
> > +	if (strncmp(tmp, find, len))
> > +		return false;
> > +	tmp += len;
> > +	*src = tmp;
> > +	return true;
> > +}
> 
> hrm.  Isn't there a standard string.h way of doing this?
> 
> If not, it looks like a pretty common thing.  I'd suggest that it a) be
> coded to not do two passes across the input and b) proposed as a
> generic addition to the kernel's string library functions.
> 
> > +static void normalize_line(unsigned char *buffer)
> > +{
> > +	unsigned char *sp = buffer;
> > +	unsigned char *dp = buffer;
> > +	bool first = true;
> > +
> > +	while (*sp && (*sp <= ' ' || *sp >= 127))
> > +		sp++;
> > +	while (*sp) {
> > +		if (!first)
> > +			*dp++ = ' ';
> > +		first = false;
> > +		while (*sp > ' ' && *sp < 127)
> > +			*dp++ = *sp++;
> > +		while (*sp && (*sp <= ' ' || *sp >= 127))
> > +			sp++;
> > +	}
> > +	*dp = '\0';
> > +}
> 
> that looks pretty generic as well.
> 
If you think TOMOYO's way of string representation (described below) is useful,
I'd like to propose these functions as generic functions.

> It seems to have duplicated isprint() in lots of places.
> 
It is different from "isprint()".

TOMOYO uses only 0x21 - 0x7E (as printable characters) and 0x20 (as word
delimiter) and 0x0A (as line delimiter).

> What happens if I have a filename which includes a character in the
> 128->255 range?

0x01 - 0x20 and 0x80 - 0xFF will be handled in \ooo style representation.
The reason to use \ooo is to guarantee that "%s" won't damage logs.
Userland program can request

 open("/tmp/file granted.\nAccess /tmp/file ", O_WRONLY | O_CREAT)

and auditing such crazy pathname using "Access %s denied.\n" format
will results in "fabrication of audit logs" like

 Access /tmp/file granted.
 Access /tmp/file rejected.

TOMOYO converts such characters to \ooo so that the auditing will generate

 Access /tmp/file\040granted.\012Access\040/tmp/file rejected.

and the administrator can read the audited logs safely using /bin/cat .

> > +struct domain_info *tmy_find_domain(const char *domainname)
> > +{
> > +	struct domain_info *domain;
> > +	struct path_info name;
> > +
> > +	name.name = domainname;
> > +	tmy_fill_path_info(&name);
> > +	list1_for_each_entry(domain, &domain_list, list) {
> > +		if (!domain->is_deleted &&
> > +		    !tmy_pathcmp(&name, domain->domainname))
> > +			return domain;
> > +	}
> > +	return NULL;
> > +}
> 
> No lock was taken to protect that list.
> 
No lock needed for protecting "list1" list.
list1 was reviewed by Paul E. McKenney. ( http://lkml.org/lkml/2008/10/20/4 ).

> If the caller must take some lock then that precondition should be
> documented in the function's comment.
> 
To your surprise, most functions are lock free, due to use of
"append only singly linked list" named "list1".
Only tmy_real_domain() requires the caller to take "tasklist_lock".
tmy_read_control() and tmy_write_control take "struct tmy_io_buffer"->io_sem
before calling "struct tmy_io_buffer"->read and "struct tmy_io_buffer"->write
methods.
All other functions don't require the caller to take some lock.

> > +/**
> > + * path_depth - Evaluate the number of '/' in a string.
> > + *
> > + * @pathname: The string to evaluate.
> > + *
> > + * Returns path depth of the string.
> > + *
> > + * I score 2 for each of the '/' in the @pathname
> > + * and score 1 if the @pathname ends with '/'.
> > + */
> > +static int path_depth(const char *pathname)
> > +{
> > +	int i = 0;
> > +
> > +	if (pathname) {
> > +		char *ep = strchr(pathname, '\0');
> 
> what?  Does that even work?  strchr(p, 0) should always return NULL:
> 
> RETURN VALUE
>        The strchr() and strrchr() functions return a pointer  to  the  matched
>        character or NULL if the character is not found.
> 
> 
> Using
> 
> 	pathname + strlen(pathname)
> 
> would be saner, no?
> 
strchr(p, 0) returns the location of '\0', not NULL.
But, "p + strlen(p)" could generate faster assembly code than "strchr(p, 0)".
Replaced "strchr(p, 0)" by "p + strlen(p)".

> > +		if (pathname < ep--) {
> > +			if (*ep != '/')
> > +				i++;
> > +			while (pathname <= ep)
> > +				if (*ep-- == '/')
> > +					i += 2;
> > +		}
> > +	}
> > +	return i;
> > +}
> 
> I cannot imagine why this function exists :(
> 
To hash string for faster comparison.

> > [vast amounts of string hacking snipped]
> 
> This seems like madness, sorry.
> 
> Why the heck is so much string bashing going on in here???
> 
Yeah, You would go crazy with functions that handle string data.
But these functions are needed to stay inside the kernel for validating,
hashing and comparing string data.

> > +/**
> > + * tmy_io_printf - Transactional printf() to "struct tmy_io_buffer" structure.
> > + *
> > + * @head: Pointer to "struct tmy_io_buffer".
> > + * @fmt:  The printf()'s format string, followed by parameters.
> > + *
> > + * Returns true on success, false otherwise.
> 
> This comment should explain what the terms "success" and "failure"
> refer to.  Perhaps "success"=="the output didn't overflow" or something.
> 
Replaced "Returns true on success" by "Returns true if output was written".

> > +static const char *tmy_get_exe(void)
> > +{
> > +	struct mm_struct *mm = current->mm;
> > +	struct vm_area_struct *vma;
> > +	const char *cp = NULL;
> > +
> > +	if (!mm)
> > +		return NULL;
> > +	down_read(&mm->mmap_sem);
> > +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > +		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
> > +			cp = tmy_realpath_from_path(&vma->vm_file->f_path);
> > +			break;
> > +		}
> > +	}
> > +	up_read(&mm->mmap_sem);
> > +	return cp;
> > +}
> 
> What guarantees that the first executable mapping in the mapping list
> is the correct one for the executable?
> 
It is just for auditing. Not for security decision.

> What prevents us from accidentally breaking that guarantee in the
> future?  I wasn't even aware that this was the case.
> 
> What happens if the executable was unlinked?
> 
audit_log_task_info() is doing the same thing.

> > +/**
> > + * tmy_check_flags - Check mode for specified functionality.
> > + *
> > + * @domain: Pointer to "struct domain_info".
> > + * @index:  The functionality to check mode.
> > + *
> > + * Returns the mode of specified functionality.
> 
> That description is rather meaningless.
> 
Removed the description.

> > +unsigned int tmy_check_flags(const struct domain_info *domain, const u8 index)
> > +{
> > +	const u8 profile = domain->profile;
> > +
> > +	if (unlikely(in_interrupt())) {
> > +		static u8 count = 20;
> > +		if (count) {
> > +			count--;
> > +			printk(KERN_ERR "BUG: sleeping function called "
> > +			       "from invalid context.\n");
> > +			dump_stack();
> > +		}
> > +		return 0;
> > +	}
> 
> a) WARN_ON is preferred
> 
> b) WARN_ON_ONCE might be usable here
> 
> c) what on earth is this code doing??
> 
Replaced "count" with "WARN_ON".

TOMOYO checks only process context.
This code disables TOMOYO's enforcement in case the function is called from
interrupt context.

> > +	return sbin_init_started && index < TMY_MAX_CONTROL_INDEX
> > +#if MAX_PROFILES != 256
> > +		&& profile < MAX_PROFILES
> > +#endif
> > +		&& profile_ptr[profile] ?
> > +		profile_ptr[profile]->value[index] : 0;
> > +}
> 
> And this.  I cannot imagine why Tomoyo cares whether /sbin/init has
> started yet.  This sort of thing should be commented!
> 
TOMOYO loads policy using /sbin/tomoyo-init when /sbin/init starts.
Replaced "sbin_init_started" by "tmy_policy_loaded".

> What happens in a cgroups environment where there will be multiple
> /sbin/inits running?
Nothing. /sbin/tomoyo-init is called only for the first time /sbin/init
is requested and /sbin/tomoyo-init exists.

> > +/**
> > + * tmy_check_domain_quota - Check for domain's quota.
> > + *
> > + * @domain: Pointer to "struct domain_info".
> > + *
> > + * Returns true if the domain is not exceeded quota, false otherwise.
> > + */
> 
> This function is poorly named.
> 
Replaced "tmy_check_domain_quota" by "tomoyo_domain_quota_is_ok".

> > +/**
> > + * tmy_find_or_assign_new_profile - Create a new profile.
> > + *
> > + * @profile: Profile number to create.
> > + *
> > + * Returns pointer to "struct profile" on success, NULL otherwise.
> > + */
> > +static struct profile *tmy_find_or_assign_new_profile(const unsigned int
> > +						      profile)
> > +{
> > +	static DEFINE_MUTEX(lock);
> > +	struct profile *ptr = NULL;
> > +
> > +	/***** EXCLUSIVE SECTION START *****/
> > +	mutex_lock(&lock);
> > +	if (profile < MAX_PROFILES) {
> 
> This check didn't need to be inside the lock.
> 
Moved the "if" to before the lock.

> > +/**
> > + * write_profile - Write profile table.
> 
> where to?
> 
Write to profile table. Fixed.

> > +/**
> > + * read_profile - Read profile table.
> 
> Where from?
> 
Read from profile table. Fixed.

> These functions appear to be implementing more userspace interfaces.
> 
> The userspace interface is the most important part of any kernel code. 
> We can change all the internal details, but the interfaces will live
> forever.
> 
> Hence we should review the proposed interfaces before even looking at
> the code.  Indeed, before even writing the code.
> 
> What are the Tomoyo kernel interfaces?

I'll describe it in other posting.

> > +/* Structure for policy manager. */
> > +struct policy_manager_entry {
> > +	struct list1_head list;
> > +	/* A path to program or a domainname. */
> > +	const struct path_info *manager;
> > +	bool is_domain;  /* True if manager is a domainname. */
> > +	bool is_deleted; /* True if this entry is deleted. */
> > +};
> > +
> > +/*
> > + * The list for "struct policy_manager_entry".
> > + *
> > + * This list is updated only inside update_manager_entry(), thus
> > + * no global mutex exists.
> > + */
> > +static LIST1_HEAD(policy_manager_list);
> > +
> > +/**
> > + * update_manager_entry - Add a manager entry.
> > + *
> > + * @manager:   The path to manager or the domainnamme.
> > + * @is_delete: True if it is a delete request.
> > + *
> > + * Returns 0 on success, negative value otherwise.
> > + */
> 
> eh?  So deleted entries get their "is_deleted" flag set but they are
> never actually removed from the list nor freed?  So over time the list
> gets longer and longer and consumes more and more memory?
> 
Right. Most of elements are allocated when /sbin/init starts, and they 
are referred during lifetime of the kernel. Deleted entries get their 
"is_deleted" flag set but they are never actually removed from the list 
nor freed. But don't worry. The amount of memory used by TOMOYO is quite 
small (about 1MB or so).

> > +/**
> > + * write_manager_policy - Write manager policy.
> > + *
> > + * @head: Pointer to "struct tmy_io_buffer"
> > + *
> > + * Returns 0 on success, negative value otherwise.
> > + */
> 
> More userspace ABI proposals?
> 
Yes. But, it is only for TOMOYO's management tools.
TOMOYO requires no modification of existing userland programs
and provides no API for existing userland programs.

> > +/**
> > + * is_policy_manager - Check whether the current process is a policy manager.
> > + *
> > + * Returns true if the current process is permitted to modify policy
> > + * via /sys/kernel/security/tomoyo/ interface.
> > + */
> > +static bool is_policy_manager(void)
> > +{
> > +	struct policy_manager_entry *ptr;
> > +	const char *exe;
> > +	const struct task_struct *task = current;
> > +	const struct path_info *domainname = tmy_domain()->domainname;
> > +	bool found = false;
> > +
> > +	if (!sbin_init_started)
> > +		return true;
> > +	if (!manage_by_non_root && (task->cred->uid || task->cred->euid))
> > +		return false;
> 
> What happens in a containerised environment where uids are non-unique
> and where there are multiple /sbin/inits?
> 
This interface is designed to be accessed by processes having init_pid_ns
namespace.

> > +	if (!found) { /* Reduce error messages. */
> > +		static pid_t last_pid;
> > +		const pid_t pid = current->pid;
> > +		if (last_pid != pid) {
> > +			printk(KERN_WARNING "%s ( %s ) is not permitted to "
> > +			       "update policies.\n", domainname->name, exe);
> 
> It appears that unprivileged userspace can cause this messge to be
> printed at will.  That can cause the logs to fill and is considered to
> be a small denial of service security hole.
> 
By default, this pseudo file is "root:root" and it's permission is 0600.

> > +static bool is_select_one(struct tmy_io_buffer *head, const char *data)
> > +{
> > +	unsigned int pid;
> > +	struct domain_info *domain = NULL;
> > +
> > +	if (sscanf(data, "pid=%u", &pid) == 1) {
> 
> PIDs are no longer system-wide unique, and here we appear to be
> implementing new userspace ABIs using PIDs.
> 
This interface is designed to be accessed by processes having init_pid_ns
namespace.

> > +static int write_domain_profile(struct tmy_io_buffer *head)
> > +{
> > +	char *data = head->write_buf;
> > +	char *cp = strchr(data, ' ');
> > +	struct domain_info *domain;
> > +	unsigned long profile;
> > +
> > +	if (!cp)
> > +		return -EINVAL;
> > +	*cp = '\0';
> > +	domain = tmy_find_domain(cp + 1);
> > +	strict_strtoul(data, 10, &profile);
> 
> Unchecked return value?
> 
Added checking.

> > +/* path to policy loader */
> > +static const char *tmy_loader = "/sbin/tomoyo-init";
> 
> hm, hard-wired knowledge of filesytem layout.
> 
> We did this in a few places already, reluctantly.  We did at least make
> them configurable (eg: /proc/sys/kernel/modprobe).
> 
> It's rather ugly to be doing this sort of thing.
> 
This pathname is embedded into the kernel to avoid modification of
userland program.
/proc/sys/kernel/tmy_loader seems redundant. Should we use __setup()?

> > +static bool policy_loader_exists(void)
> > +{
> > +	/*
> > +	 * Don't activate MAC if the policy loader doesn't exist.
> > +	 * If the initrd includes /sbin/init but real-root-dev has not
> > +	 * mounted on / yet, activating MAC will block the system since
> > +	 * policies are not loaded yet.
> > +	 * Thus, let do_execve() call this function everytime.
> > +	 */
> > +	struct nameidata nd;
> > +
> > +	if (path_lookup(tmy_loader, LOOKUP_FOLLOW, &nd)) {
> > +		printk(KERN_INFO "Not activating Mandatory Access Control now "
> > +		       "since %s doesn't exist.\n", tmy_loader);
> > +		return false;
> > +	}
> > +	path_put(&nd.path);
> > +	return true;
> > +}
> 
> If you really really have to do this then a simple call to sys_access()
> might suffice.
> 
To use sys_access(), we need to add get_fs()/set_fs() stuff.
It's not simple.

> But it is of course racy against concurrent rename, unlink, etc.
> 
Racing is not a problem. Policy loader is called *only once* upon boot.

> > +void tmy_load_policy(const char *filename)
> > +{
> > +	char *argv[2];
> > +	char *envp[3];
> > +
> > +	if (sbin_init_started)
> > +		return;
> > +	/*
> > +	 * Check filename is /sbin/init or /sbin/tomoyo-start.
> > +	 * /sbin/tomoyo-start is a dummy filename in case where /sbin/init can't
> > +	 * be passed.
> > +	 * You can create /sbin/tomoyo-start by
> > +	 * "ln -s /bin/true /sbin/tomoyo-start".
> > +	 */
> > +	if (strcmp(filename, "/sbin/init") &&
> > +	    strcmp(filename, "/sbin/tomoyo-start"))
> > +		return;
> > +	if (!policy_loader_exists())
> > +		return;
> 
> Why do this?  call_usermodehelper() will simply fail if the file isn't here.
> 
Without policy_loader_exists(), the system will panic() if
/sbin/init is requested but the policy loader doesn't exist.

> > +	printk(KERN_INFO "Calling %s to load policy. Please wait.\n",
> > +	       tmy_loader);
> > +	argv[0] = (char *) tmy_loader;
> > +	argv[1] = NULL;
> > +	envp[0] = "HOME=/";
> > +	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
> > +	envp[2] = NULL;
> > +	call_usermodehelper(argv[0], argv, envp, 1);
> > +
> > +	printk(KERN_INFO "TOMOYO: 2.2.0-pre   2008/10/10\n");
> > +	printk(KERN_INFO "Mandatory Access Control activated.\n");
> > +	sbin_init_started = true;
> > +	{ /* Check all profiles currently assigned to domains are defined. */
> > +		struct domain_info *domain;
> > +		list1_for_each_entry(domain, &domain_list, list) {
> > +			const u8 profile = domain->profile;
> > +			if (profile_ptr[profile])
> > +				continue;
> > +			panic("Profile %u (used by '%s') not defined.\n",
> > +			      profile, domain->domainname->name);
> > +		}
> > +	}
> > +}

> > +/**
> > + * read_updates_counter - Check for policy change counter.
> > + *
> > + * @head: Pointer to "struct tmy_io_buffer".
> > + *
> > + * Returns how many times policy has changed since the previous check.
> > + */
> > +static int read_updates_counter(struct tmy_io_buffer *head)
> > +{
> > +	if (head->read_eof)
> > +		return 0;
> > +	tmy_io_printf(head,
> > +		      "/sys/kernel/security/tomoyo/domain_policy:    %10u\n"
> > +		      "/sys/kernel/security/tomoyo/exception_policy: %10u\n"
> > +		      "/sys/kernel/security/tomoyo/profile:          %10u\n"
> > +		      "/sys/kernel/security/tomoyo/manager:          %10u\n",
> > +		      atomic_xchg(&updates_counter
> > +				  [TMY_UPDATES_COUNTER_DOMAIN_POLICY], 0),
> > +		      atomic_xchg(&updates_counter
> > +				  [TMY_UPDATES_COUNTER_EXCEPTION_POLICY], 0),
> > +		      atomic_xchg(&updates_counter
> > +				  [TMY_UPDATES_COUNTER_PROFILE], 0),
> > +		      atomic_xchg(&updates_counter
> > +				  [TMY_UPDATES_COUNTER_MANAGER], 0));
> > +	head->read_eof = true;
> > +	return 0;
> > +}
> 
> What is this doing?  We print the absolute pathnames of sysfs files via
> another sysfs file?
> 
This is an interface to allow GUI management tool to examine policy changes.
But removed because GUI management tool is not ready to support this version.

> > +static int tmy_read_control(struct file *file, char __user *buffer,
> > +			    const int buffer_len)
> > +{
> > +	int len = 0;
> > +	struct tmy_io_buffer *head = file->private_data;
> > +	char *cp;
> > +
> > +	if (!head->read)
> > +		return -ENOSYS;
> > +	if (!access_ok(VERIFY_WRITE, buffer, buffer_len))
> 
> Unneeded - copy_to_user() checks this.
> 
Removed.

> > +/**
> > + * tmy_write_control - write() for /sys/kernel/security/tomoyo/ interface.
> > + *
> > + * @file:       Pointer to "struct file".
> > + * @buffer:     Pointer to buffer to read from.
> > + * @buffer_len: Size of @buffer.
> > + *
> > + * Returns @buffer_len on success, negative value otherwise.
> > + */
> > +static int tmy_write_control(struct file *file, const char __user *buffer,
> > +			     const int buffer_len)
> > +{
> > +	struct tmy_io_buffer *head = file->private_data;
> > +	int error = buffer_len;
> > +	int avail_len = buffer_len;
> > +	char *cp0 = head->write_buf;
> > +
> > +	if (!head->write)
> > +		return -ENOSYS;
> > +	if (!access_ok(VERIFY_READ, buffer, buffer_len))
> 
> Unneeded.
> 
I know. But to avoid partial copy, I check here too.

> > +/* Common header for holding ACL entries. */
> > +struct acl_info {
> > +	struct list1_head list;
> > +	/*
> > +	 * Type of this ACL entry.
> > +	 *
> > +	 * MSB is is_deleted flag.
> > +	 */
> > +	u8 type;
> > +} __attribute__((__packed__));
> 
> I cannot tell from reading the code why this is packed.  Hence a comment
> is needed.
> 
Packing "struct acl_info" allows "single_path_acl_record" to embed "u16" and
"struct double_path_acl_record" to embed "u8" without enlarging their structure
size. I added a comment.

> Please use __packed.
Replaced "__attribute__((__packed__))" with "__packed".

> > +/* The kernel's domain. */
> > +extern struct domain_info KERNEL_DOMAIN;
> 
> Why upper-case?
> 
Replaced "KERNEL_DOMAIN" by "kernel_domain".

> Many of the symbols which this header defines have quite
> generic-sounding names.  it would be better if their names were to
> identify the symbols as being part of Tomoyo.
> 
Added "tomoyo_" to all symbols.


